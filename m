Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC9ECA5FE6
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 18:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55B16B008A; Sat,  3 Oct 2026 14:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05C06B008C; Sat,  3 Oct 2026 14:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CDBC6B0092; Sat,  3 Oct 2026 14:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65B8E6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:02:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E11C8A7B1E
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 18:02:33 +0000 (UTC)
X-FDA: 85282084986.24.2972A38
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf17.hostedemail.com (Postfix) with ESMTP id DBEF04000F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 18:02:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=truenas.com header.s=google header.b=jVvxaDGc;
	spf=pass (imf17.hostedemail.com: domain of ameer.hamza@truenas.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=ameer.hamza@truenas.com;
	dmarc=pass (policy=quarantine) header.from=truenas.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791050552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fA35AzLMLI8IsjeYb5yaRW8LrQiraBlfHGAy9JiyXU=;
	b=FkEOINtiTpwFkL0B7BS4nykBx4tfrqDAvP4SVOuRSkrRJgAlLVn8rblAiHXtnBCayQY2V7
	7AsKHGsSvZoLrLczWYOxqaVOV2VS00HPg90mwB9BrmLjNfzl1Zl6vA8DeYKJuEa1tpC2J6
	wGj5Op6alghnRB467PxOb0rJOCGeE6c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=truenas.com header.s=google header.b=jVvxaDGc;
	spf=pass (imf17.hostedemail.com: domain of ameer.hamza@truenas.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=ameer.hamza@truenas.com;
	dmarc=pass (policy=quarantine) header.from=truenas.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791050552;
	b=MD0conR9+RTSsgvLvPUIhunMLNpU85GrdHM9KzWA/A/+Spo777PWgXrcEEcIY2u04EUFcF
	YKYZ16wwA8EVVH4OUTdyKZ6mvKPf6AV2uCKhPS+heWdjLNK4wGp1bCfKLgCl06CI6v21P0
	XU2U5pYkoPUquSV/D8FjYTSVVSM91+Y=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a0280d4f56so4259965e9.2
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 11:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truenas.com; s=google; t=1791050550; x=1791655350; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1fA35AzLMLI8IsjeYb5yaRW8LrQiraBlfHGAy9JiyXU=;
        b=jVvxaDGcmKraJjbhlU6zY5meN9H5GwnOOdVu+pTZPJwqVg2h7yKkzreaDP6/z4G7vn
         9faf2oJx+77TyCdIaPH2gz1A7yYgcIMD4ers58cl7WuZzsL70YEaTIqVTatLg9P62bm+
         eXeRd/s6FGnXpMxXYGUBq0aVTiuimK22jTf3mLhmugZ35vkIezzB9e8nta8AXSLSjDAn
         UaUhbwuBG95e9xlQXqE1B0/Dyrs2dHfTldU2u8yXlSk6y3+wn8y6Trvze12FSRIGJy94
         zvNVdmreLK3epLJYPXTRZS88pUpUqtfmolyFszyhr26Y1tDgsSelHPe3oo8FsLUZhnEx
         MZFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791050550; x=1791655350;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1fA35AzLMLI8IsjeYb5yaRW8LrQiraBlfHGAy9JiyXU=;
        b=lnPYU7NfOhtcyrg6y8Lc7tgjFyZlAmbhkVNq+6EkUV8nPRvjOJzv8SYTAFl036TkBv
         mc8832+67MAlCNAf9g4eBE6f08X0dtXlrkN+zwZFPLZbYy5NvPJj5CtSIjjL6ncxM6Cz
         EVPJHH1w4p3QFPLSF0mo559KJCse3nI1sPN/GMvm1V5o2O1os4NaO9DYuQ3N6u8KrjXz
         TbhXA/MLHax8OGSC3OyWNNsez7C2OVeKVB5o/vowjatrUQTIxYekvnLMNSNmY6JZIOmo
         VQ194229Xktc+AqRivgFHKim+2aN1Do1LPkFWgBH2wjgaoh3hzsyyF5FO7xyh/vWqik9
         O0EQ==
X-Forwarded-Encrypted: i=1; AKwUvByNGTaH9hUP29r85rRnHq6OC6JiFpwYLgUMcCC5So18XAguoTbGqe8Mv5mR1XOQ+v5d6HnztKXvvg==@kvack.org
X-Gm-Message-State: AFuF++ldw7wlK5ATa1yVA9NgViXuToq5ycDfEUSchQ+iqQlThNM63pFa
	/A3iFTp816vKVwMCqHqMMfn2fbkKkgXqYKxrRqpE+cf9GGn9DqPIcyWDBMC/7GyJbQ==
X-Gm-Gg: AYBFou1/wWkLO1AWWFuViZLV81Z6IIUnfWkUzqbw5actFPAS7uX7t4r/1J6r7sd5R5x
	sb/4e/Np291V65l1h01GNy6yiB/U0Wn2XircaAWfzUs0sDf8MFtxiHpG1YwG2RIOXQ78Y8i+gtc
	DVG8ihtSkEI4X8Vkfr4wLNJhm+T8z6o9PM1kgcPizl086+gQxUG71ix5xnqooiggdcZElbH3z96
	dneML8VH+gPJHvq/Cav10nEpI0CwOThbG2VftJVRETrZnSJyD5jHS033Io1s/ydTTC/1b3MI1Pc
	zGylfr5g+08s5fGM7OJ0MV+4JeQxBMSkvcUo5ZheKgO/EeRr65zS0JI/LnElT3Mz7+wInKgHjc1
	T+nksiPzqfRhrx4KhcgEoTOkJPkN7smFvUf/gS/WnDL7wtZpECYwJkuCsGf7znJiV+tQcZ8vZGR
	K5vztEtVQ0nlBOwMy9x9tV65StzmRyJC0JX3HWgnA0aisih1XQ6Q==
X-Received: by 2002:a05:600c:4e55:b0:49e:823a:9dec with SMTP id 5b1f17b1804b1-4a0274e9c4amr107646605e9.3.1791050550421;
        Sat, 03 Oct 2026 11:02:30 -0700 (PDT)
Received: from hamza-PC ([2400:adc1:158:c700::2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b382f89c3sm12646948f8f.34.2026.10.03.11.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 11:02:29 -0700 (PDT)
Date: Sat, 3 Oct 2026 23:02:24 +0500
From: Ameer Hamza <ameer.hamza@truenas.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: rppt@kernel.org, peterz@infradead.org, akpm@linux-foundation.org, 
	david@kernel.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, stable@vger.kernel.org, 4ncienth@gmail.com, sashal@kernel.org, 
	alexander.motin@truenas.com, caleb.stjohn@truenas.com
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while
 perf record runs
Message-ID: <asFC2Oryo2-9ww5r@hamza-PC>
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
 <asEllR7if-J3wteg@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asEllR7if-J3wteg@gremlin>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DBEF04000F
X-Stat-Signature: 4ypebry5khrnwc13m7kipdsajpx4k7zt
X-Rspam-User: 
X-HE-Tag: 1791050551-587795
X-HE-Meta: U2FsdGVkX18jhOMad+9DcTbL9NvD0MFuYFHuU9Ljtvlhq/goTq5ihyBw+VH6cJJFlWjW3/WaRiHu39+4YiS05oB+sdRbkvs1UWi/nitwELIxlD1e1kwNGQNJP6IgqXb7fnFF84YwWJ9xWdTOYMK5UsrIOs1i2pL7uZZGTdfvKufVe74rXe/uUrMy7brAUK7l0qWbUIfrVE+xlMcqC5fhVD97p1kYgwbuP1H/DSktrtq7v+jBsdZt3ePariYzFDnP+nuBTu6DUhoT4tfG/E1sqE2v2ybQh4S0y+MD8RlEpd8YAZhqKY8nbcx1Jic7ML2ThNaVmqDy61oshfsvqG5AufHUCA+maUX200PTcPZYnC1khg//iWvuTJGWaaz63Fpbmy4Pad1EmRK+zGsxB4IE8BoDbD30Xbq22N93Sf7k2Vf38/OZuwz0KEvA3QR0NiZHiHmNjNWOIMqtghpZ0TGfigW0dsdl5/D2VoltjBarSwHE1hTuzYcS49NhtRMW7G41Joo3XQ9TCnkmBGfgt3iWydY/BxiLd4EMdXz1D8LSsnTcmo1NDnWo5qU4+YlDBPTkZiJl1kLNTpMm/7IN+Ipbov/gSRJH/BaV8QTDefM7u4WerATRhh7XHIRwpThqRnrY3UOkP3dmGueSQczLy36Kgje+cr6MhZSGE7VLBxbK8FGqnqBVcvTzAZWApg4rJfjh+EDUrOV1po7EV1SetCs7V5ybyPzmY1rN+4aXVPcUVRUjIcq/RRS6FmrvisxWG3hsEkidchWwcj6J3Zqx8ILwlRpkmcjht3fBycI0iqns6OghqAzBRgwAIQ6Wgky9Z/8Riw6nymr3bcGvm6m8v5Wo1PT0hwTMHW/gJ2w/jtfGdmLlLSY1ao5MEZYmIMhz3uIHj0RA9SC/z+P725oVGHODT0KO7A1vFb3iX/fHPnBH5m8dLxnn+Hoe/QjstbnaKY8zloYEQiSLOMRW9z9T5IC
 h1MgK+9/
 km35xO2qC4yf97jzugPFijruL7xwQOfcXMSzhEjt8rgCgVSWB/8hnuUhigyyZUxg5LM0HFg+E+LZabjYo803LDuBFMAThbS36F9wFoqCtmuC/5h8Fh2w8t6cGQn2ikRlyAwZYjP+YVZVg7vDYFncdYklXBsAmOjwfWo1oI9ycfwScAlENvkZBU8+nHwtsEJlGGGuI1/5pxpsbs+8EcPvPbsF3AzKYLUZdSKjUzIOPY6kE7lBgm+VyIxrJl8XodftCDNydTccXQtTE9Dpf6L0kzgrkSfVpkXOptntTAxLAGI2LatZKGi1Vbnuv3qzfDJmW+Z6W0dIHnYM6iAzfvR2NjC9NTde18IwcFGrQ9udBa/HWKlMHtIa72Fdti1FPAQYYTU7WC/xS/8BvygpucubaX9dFrMMI43B/vcl+9uXcAJdZVxSWWqgi9L64nJYinQIEpa7O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 04:56:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> So this is a bug in perf, which should use its own counter for this,
> AFAICT.

Agreed, and the report's closing question pointed the same way, since
the commit itself closes a real hole. Glad the longstanding perf bug is
getting fixed as a result. Thanks for the analysis and for turning the
fix around so quickly.

Thanks,
Ameer Hamza

