Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 080DDEC1120
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA566B0089; Mon, 23 Feb 2026 14:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67ADB6B008A; Mon, 23 Feb 2026 14:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8C56B008C; Mon, 23 Feb 2026 14:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC836B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:48:57 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 07D641A02E5
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:48:57 +0000 (UTC)
X-FDA: 84476759514.07.A36E8F1
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com [209.85.167.196])
	by imf11.hostedemail.com (Postfix) with ESMTP id 32D3440005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:48:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cHfdVR6S;
	spf=pass (imf11.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.167.196 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771876135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/INDuD5oX/oIvPRSYGNo5VYV57G9J3tLcJGQ9mtqQk=;
	b=IM8z+TcKJKJaUI77+uw3+hbtDxtzHfRKG1V3BqYSc65BHATUMv2FMOeYwmgiUHmVNdg/Bb
	zFPEqcYFfW/ajzLGVH6OJecrZLDak3lSbJSMa1XQQ5ktZbFbr6tZl5LMVsVtpbKGK49sYu
	R6r2Gp2ppEw+WX6/8/n8I++WQ8eIRz0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cHfdVR6S;
	spf=pass (imf11.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.167.196 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771876135; a=rsa-sha256;
	cv=none;
	b=8fF42vHkNTfAX/WLRAuRSiNKiwoiAJ4ktjPZ5iy2ps3XoKVWFfwNiAD0ziK0mVpCmKCLtA
	l3nb0QVkCYOcl+FFgg+Fq47vNHnc8kjIZ3hDA7Pqzf9VAJkCeQLOTP427nmOzjrmUpA5+J
	AU1ipdHKUfg43qGzpve15GTnbJ7YZzU=
Received: by mail-oi1-f196.google.com with SMTP id 5614622812f47-4645dde00a7so1433954b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771876134; x=1772480934; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m/INDuD5oX/oIvPRSYGNo5VYV57G9J3tLcJGQ9mtqQk=;
        b=cHfdVR6SHaXL8g6sp1oTbwgvBHX3rzf4FBF9HMnM6RvrbJLMKIWoh8gAdtSNBkl7UW
         s5pIEogIse4tjxAaf2Xrb+REJXoh/syD6GrLwHw8VhX8nTTbWVQegopI4wCqpAaAq5Z3
         E7UOJCvKVgJlADnkk1SFAExKRDspfN/tsIBFsI59NN2jbbrUeOopBnt9DWxcJ83dnTYt
         WUDg4tzLWDmyE64Cx8xrl6rOf6I4PKc6vuXFN3Vh8KNYOzPft7cDfPYu7ea+CHf4Ngv+
         Q7m2zkE028C6NkX2msSXnCpSdlpgBcToWdOypXbGtPln3OngCLIiU8ZUmns5+LZzGpBx
         02ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771876134; x=1772480934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m/INDuD5oX/oIvPRSYGNo5VYV57G9J3tLcJGQ9mtqQk=;
        b=ZvtzcOuPgeb5vbhq9FMppkXo5exN9RaTVJmRz3nK16ACEHbR2sRlmvTmySf3KFDDxb
         nohPlAyOkpREp7rOkoBHe2QVmH3yP7xfTYJlPghGuQGouWMxtoSAnmIyre7BNr6S0kYm
         lXmsIoBMXXeZuzOhqr9o53ou4UcUpN12JLO7tZhd6Iyh+yQy3dBWVC1sq5sPCPK+vnYy
         pjJ6aPAq2w7/EI6+OyBXmsujGdid3/F6leI8H9bs0iHxTU6FTma5i7gfFqH3YrmsDd8p
         td9oPmclraoUjYTRinHjPB+NOu+75DaF8TTgI0qgiPTtpf3n1XtWR+w31ixUpSpxIyhM
         73hg==
X-Forwarded-Encrypted: i=1; AJvYcCXMYDqkm3N5YxAoj/YrUxXzaozz3icJ+8muaSCcogjzi05i1aletx+XXNPbxnQjPh2g5Q14VgyNow==@kvack.org
X-Gm-Message-State: AOJu0Yxht5S8vBAaMzMaoPc+xyn3GSQ8n6ZA0ZZUrH2BBB+2DTQf427X
	EeLxVGTM8BmDg5JAYq2tBobDPN0zop4qu/kHRGf3SBVKvNwxcM6jxUFM
X-Gm-Gg: AZuq6aLpLqlHjRYBujtKpUJAV3P+PMVx8UVeMFog3vtHzjnbzeRcDnBnuYvf+XxcqsQ
	9T2EUCbopk4OcfIYm1deWhpScjpZ8rnQCP3u7MqTF8suS3u5WWx0Rfygc+Ius/hxa2Jxry7c/4t
	A0f/Chr6UJO0mz6CGtTdrllNXjCi/VAmb/G/3NeN/e5hMQTsNr6McREpA9W1dmQgRpp/HwmWvla
	Z5l0VG78J8x11I2vBeACIj0gzSwTHgvaPQP/EMFFKgaYLiHTulQveTF1QMnS6aO/7Gl0uwLiBQI
	yu3wVU9NTjvoih3DCcMYJm5bem+rm3eoaRynR4QyzkqF/kfDEfQ8qEOZHbnNGzQ2SYyINhcPF1R
	+uOVl/wFZQrPnkDf/7EaBD1UBeqjRSTXhFSj/SKALGgBaCFuObkVufGwjK9BKkx/DoL9g3Tma7n
	RRBLezUZSMVOgfPw0Ka9jv+9PrUlK0YuSbB5NsLBfLtEponiPO
X-Received: by 2002:a05:6808:30a0:b0:45e:f078:2d0f with SMTP id 5614622812f47-46447273793mr5550871b6e.30.1771876134191;
        Mon, 23 Feb 2026 11:48:54 -0800 (PST)
Received: from fedora ([2603:8080:10f0:ab80::1382])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46460661eeesm3113255b6e.13.2026.02.23.11.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 11:48:53 -0800 (PST)
Date: Mon, 23 Feb 2026 11:48:50 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: memcontrol: switch to native NR_VMALLOC
 vmstat counter
Message-ID: <aZyvIhCmVbKWeBL3@fedora>
References: <20260223160147.3792777-1-hannes@cmpxchg.org>
 <20260223160147.3792777-2-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223160147.3792777-2-hannes@cmpxchg.org>
X-Stat-Signature: ywen151aoazxn4obowupqe9sgmz515zx
X-Rspam-User: 
X-Rspamd-Queue-Id: 32D3440005
X-Rspamd-Server: rspam01
X-HE-Tag: 1771876135-863648
X-HE-Meta: U2FsdGVkX18yMMlxCx/4j8BX92V8sRi/rwVrTmlNvcoSb3cXwk3zQwj+KjbHwc3IAdF1n9x3RsWwgP6AfBwUuPw+E2rzTIygS0uQF4jPNeJknKiv6aItySk2T5RCyNLYkltSGP0ViJ/KghH63Ay1uX8JQ9UC9ehesO17KrfTodVhUUVhLZgkTwITiF9im7VVjNb70pcFcvtriilPZh4mNOABhknioCg8tanFZSv8gVDtj4EILLfnaG3LMMZ61yx7TFfkZC0n9edBwtVNW1KNMw4SkFsWwh7x6XKw46/Cip6dK3cRJLwLB0z+3awee4h/J5RUeaFQvyaQaE89sCf2TOGNTfLDbPtcElyO+78I8DMHtCWm6NPVmnXKXfEnCgLahRRBnB2Xnvuw33a4JVV59iJslJ8Fu3ubcPP+r9PtPM5xtGHK69i9Zt5CpgJ3ddaar0UGhS7YsyLdamK9joiyovhmQPnt1YOwOOLotitJV6Z0YbzGven9riyFexOQ3w7My0KeWpr5gbK66ufK9l2lqZUVLUjcRKeNUiV7oscNmhmathiqtLkCY+XHfCA06Q0geuiWzfjZTPDOaL/ilvvUz5OWCiHn14f9Owo3ODStwD6YmEn0+Gd1EEOCUPHOigLP8lImjBXfx4ndm8JTK1WvJRu2qiQ6qGX1aIQjgWr4gtwVhxDR07XpfqkKM+YDfTwZqUsDT+223jNqdo3vCPpI3l0uPWDcEsKRXpqBvkkWvlJbMPETaXdo5erPSxaeWL0VvEl4k/qaVHKbqeWwXiT9jC+ng6cNBRYidborGM8JNlDJsAGsAe3CeSs97YzeROVZ4n5Y4+iCXY/EBPoYWRX7hdIQu89tgNlkITGACr1yauZfqxBVK3lG8I0jNBRlTEZ8jV9JMLSfFSQJzgl0EjwYzlZnmL8LsH/MUruS1VwP3NJF8sqZm8xQKNmCTCLBjbnI7bJ2svaVo42UQsiN2ml
 qeWtNDF4
 Pnm6+g1DXUguAzOujTutF34fE9QnPRvPHoehgFQ4AdV+4HPNg9f6vdZHmL9uLVdbtV8gnN4ClvImiPL3/plr3lIZWMHpogksqxNkAIPf5kstTxuRJXF+HdHvm4hPMNbEosmIPA/MWbnhNYIw8IU2wXqG8IoSSm/GSquDSXuoVf00yB4FNsQQkDd7dSBVtdn24QzHiQ95FHzooGIivKmzDYEsjAY+ZT/Ir3RYdaAEDwOtxl84hbA6GGH0PUjoa9SB54w5RkC5omPrE72QaHMFzW2lRSahzjEWOC00k68lCvipWx8I14PCOopmB8knF7ruz6YcOSeb5uscmSYwMhTnnYzNYYkG26seZbNVlAMIKQTywXBxb3l5msK/uHI28qHGBRac1uFLcgxyzoMBjltpai/GiVFNiinLdaCSUV21adc59GpI6DZpPEy9JdvHUhY1AHI8GSNLlEDiuQG9OtxxJoZpwjAFOPyVQmYVlDyZe5j8evYI0lJKLtva6RtJkKvrFYP/6ZHRM/+KapvdgTgB4fJgSpA8XlkfKAeP54TWbOpivW/JBrlM6FdeRZddThjJeb+QYuULlw7319YuTdJCMMgICwRr5ugMU4DRRkf35Gqg350gTXvJxci7cr7D/rdzfKwcn8zo13o93vT4ssaA37+D2t4hf8hXG/TNDADOpSOpMcPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 11:01:07AM -0500, Johannes Weiner wrote:
> Eliminates the custom memcg counter and results in a single,
> consolidated accounting call in vmalloc code.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

