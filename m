Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2CBBC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F84B6B0095; Thu, 20 Aug 2026 14:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF7C6B009B; Thu, 20 Aug 2026 14:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6A86B009D; Thu, 20 Aug 2026 14:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E81A26B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:44:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23A7A1C0CD8
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:44:40 +0000 (UTC)
X-FDA: 85122523920.19.FA6E319
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2171A40013
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:44:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PK0rq5nN;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787251478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GLmbH5SyGlm3QykfKRyFPNaJnpHjEPWRCdCFLcGOXY=;
	b=lSzR/Qjtc0Aub/yx0lRL4+oC/2tXhtNYjgwvQi5cKu8Iz3eZgvpulpkjeMDr1qtBlAtiNS
	MPV4oJA9e123hz7HumICjd/3ix5B/A3z5orjS7Y1+3xqzvp9cpmxYpXjeCm/CbYSXvsgWG
	uQbugj3EXshd/8C+nwI7hfP4Mebu0UI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PK0rq5nN;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787251478;
	b=FUA6eeG4kxuWqO2SJzNh/B0uS4w4ZSpxn3cLxjZc1xom/Vr/7Ak0pJFeh15puah1/zeWcX
	rUHKPu8cEljqDkZb4VR/LL1z8GK3TLlMMKW7Y+aqD4Y/xEfCms0H6VYHBm4HFBhweOa8Mg
	f5wvE3lOc0/0QhhmJiHsvFMv0Ldyidk=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47fe377a217so159873f8f.1
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787251477; x=1787856277; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0GLmbH5SyGlm3QykfKRyFPNaJnpHjEPWRCdCFLcGOXY=;
        b=PK0rq5nNHqKA1fVffqI9W6CWQVcs4+uonZoXDhhIMYhGfLyg/gIbUnapGJb7aPxe3H
         4ARj1ke7J2V3BLQr6P9YLv0xPCsfhe0Wqm6sA0HZftuea0cqOnYX76u6cn7hwnp83nIn
         MGAPgyHOw7bl4HkUe2Z+Qc4J73m98yylUBiyCi3Trm54AWrFOcTRyky0btOl14SZ/Rc0
         Y87+BjND3kZOSPcia9C4+LTCXvpO0cVC4VTyDBJrVKGsP4qdgCYWS3Y95qD0jlXn7qoM
         VO4HzMBl3rcqo3WKpeAJ8fjjxjWJugoqskNXzD9WyVt6FyHGlZ9L8o2X6lF0ZPA8QXTq
         14Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787251477; x=1787856277;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0GLmbH5SyGlm3QykfKRyFPNaJnpHjEPWRCdCFLcGOXY=;
        b=kFqXymQHyifY49goni7va+C8QWYmun1hy0uPraA20kUV2OMD6QTAO2goR62Zq0NGR0
         Am01PRu99SKdmIsaJvsrUYH5/kM+rGJTAxWlDwiRixwk5b1+xSFLC2RP1GtSEFFBF/HC
         Ggu6n7vPJv5zYfHsm6d+o8auzNj1G0RcfcfMxhhkT2GYuJfGTvsnUlwhn1NSCrw6dpst
         UGCm8j50kkWCDOz1RFxGnQoTWNjuxDxhngM+SGP6EVs0iPgoB2SU3MdyQmrwtq1lzgGu
         E2n+X5CkMVd/RkJeUBcoiAZxSRwoAz0xV+cCUHwPQtRJHu8zIR2Q7Mx+ZJCF90bCbsKb
         O6WA==
X-Forwarded-Encrypted: i=1; AHgh+RpYvbnUzDMSjfhQgq179/pcNbpuDRuiZ/D8R0ZUxYM3jjTYBPNFWjR5h0f7qHAUDeH0Q1Tm/ScRcA==@kvack.org
X-Gm-Message-State: AFuF++lKuPe281rA6esOqvG6a+Y3yu5hto/IQfr8VTVt3KsUrRC4LTxy
	Gny7jz2VYQobucgEyjgSFk6zJsDm64AkLYi6fP3kMbfXijExsnvt3ZLalVU2530lsBs=
X-Gm-Gg: AR+sD105ssT34XhWdHxvftQS17Rqw1AtMmpk4Cq8CEgF+nlwUjUYkgGj7Vdi2kusC27
	VU+QvSWRE+5ZIhrhRX6HuvZ83BacQiwB4+i+jdQLKxr6W0tbCL2QbOGsmVeUus7ETexkvVAMXbx
	H5ruuBmIlvAz+YzzL/w/4T6LGEmrkEJvjhGBu+FxJbSJ7J9gdyyPx2MvH2cpN7AwlvOck0NVkO9
	OioMv7BvuJV91oszLXUPJMOGyrwkFyGR5Epthdpww4qiquvKuygpJbQXa8jBB7vidqVs+j7OgHv
	26mz1ud+9mFBm1o0YlLjyVaHDrTEIf263nho1j4JloSti4YkaXcVaZ1+Ia2IGAbwJjWj7qgn5i4
	dSnhX72OKJGJnxwGmx94xyp7pifUyf0QKEmfQUNg2kzy55Qd51GP8F5se2rP9xNYePUrjZhgYEG
	UDI/CpIQSiDj1/CAEdAvCPVCj6u+H6w1OuXlMIrLUImz/tZz3U/TrDZD/8LShBnCx0F/KZzmzQR
	g==
X-Received: by 2002:a05:6000:605:b0:47f:9096:3ef1 with SMTP id ffacd0b85a97d-482c0b62092mr1209538f8f.9.1787251476739;
        Thu, 20 Aug 2026 11:44:36 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1441748sm15311174f8f.8.2026.08.20.11.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 11:44:36 -0700 (PDT)
Date: Thu, 20 Aug 2026 20:44:34 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <cxiong@meta.com>
Subject: Re: [PATCH v2] memcg: trim the per-cpu charge stock instead of
 draining it
Message-ID: <aodLEmCg76oRHY2j@tiehlicka>
References: <20260820012010.2016086-1-shakeel.butt@linux.dev>
 <aoanalsTiGmL69LN@tiehlicka>
 <aoclMssJAyYw2aCn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoclMssJAyYw2aCn@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2171A40013
X-Stat-Signature: f676sr7pp7zpyxw7hq7qxk6cghwk7b44
X-Rspam-User: 
X-HE-Tag: 1787251477-921532
X-HE-Meta: U2FsdGVkX1+EPDUyeXjctkHAd9kv8FKjz9xZFKeSn9vJlULsO/LaFfIuOwdIXshUuAIX1hKTrTqZPW8QGO0iwg6fxazIO+kQaVxjEAA/sdhblYToyi9xGzxZJcs7BbvJTuuS0ApsXajQdqjUyfjATXB7qt+Uw5eWVazxwVNS8TCjKwhu2xA623bhEiA6JuixSKANu3Ao5Qcxc+zYSnAUPwVO+T8KGoxKEgbkfP1uXUBe9jcgtz4dV7Vw3gH+XJXctIAfu26BWy0Y2F6cMVBuR6qaN9bb0KjLD9qliK4EjHOcxe1bgKNzOe+tW7xAFL6U9Ouit15WVtpOh1CB27jiDrS6y5heudtkb08K6hRiP2n6Zc3NpUj2DqKAwT53PNrqmij1npTrf2MhxEhWkJHTtBg+WyTrtANy36SNH9I7nXcKxJqOgeez3KcynjEgdA6SKrmOQEnnk4p90s0aIEiyhGkZxMOenIBbf72FA1zKBR6t/aGWFmnixQKiEo5v9t/2BMXLE5ARkY9cjWqw5RE/GF2MxmIr0juftEWNBVvTW/J0Hi4pEVFjJ6tbX4GVOd7aA4wuipcnaYfocjsd5+2Sydj50MYYuXKj8ha68xFGwyZTpl4bcmsVYfAorEkUorOXXiy3kBu6cMNIFXNT50I3b8U3dWrQXnyTEG4oLuE0je9v0ZPhbhWFJ+Hu6ewsgzujeAcDgNqglx4uTQDaMzteDC1g7Xw4OBwR7HyE/Y5bU20KY6v+E5bObnxZ4Q3BWCt1EC1SbjkICo+1eFJ5n7Fk4OoSlrACqelD0YWXvHdQvfjok+qTUSjUHhC/AoYCwGskApToMDvhfsdJn7BQLhtr1b9hAx7oO/SN4hSd3bnTLZoE+V42Ba1BypEbbyEyW5GlQk89iMp4KFf4WyiXY+zoLM9wkfaq1mb0XU0Tm7hq1zRaKD+SlDPU7l+z7O+5xrJ4pIvGuxvQ8epPc0t6w3h
 W7GjqTOU
 4TI6igiF8x5C+L/leYcw/c56wDk9efYJJdNUFZRCfiuX1PdM7hBDOlveGb/eNK2C16WCDTodDsJy0Ey8E80piK29saH45F8FMMCociDgGceG+IsPiVaA1HPKFWBhdKY4tROvj7+jLpXCzAqimEs85TcUhEKntzyNQdhDp7JAsyzRRwKobqOuztCfOdcFLjteGTkMASSIi2JV0aHKYS3frc7krmSgaKegBYddCGLV0Z9J3p3ikeHhG5A7KMfyaMiFg2QskfBuzvP0c0juw76xsSC68spr8Nac+xuddfjPYtdoSDt09tHdj3JTjLltlxmtEE8GMjcL8h/GXZH03OVDVcoj5RsYdp5a4IYFk+FFrdTX/cRqA2jIgz5S6zVDhndsosXTox4FQsyoLxb9ynwRJStNFqoY/GWx/s/mQr2+Y38Lf8R0uH/sq4kT0Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 20-08-26 09:06:29, Shakeel Butt wrote:
> On Thu, Aug 20, 2026 at 09:06:18AM +0200, Michal Hocko wrote:
> > On Wed 19-08-26 18:20:10, Shakeel Butt wrote:
> > > @@ -2254,9 +2264,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> > >  			empty_slot = i;
> > >  		if (memcg == READ_ONCE(stock->cached[i])) {
> > >  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> > > +			if (stock_pages > MEMCG_STOCK_HIGH) {
> > > +				memcg_uncharge(memcg,
> > > +					       stock_pages - MEMCG_STOCK_LOW);
> > > +				stock_pages = MEMCG_STOCK_LOW;
> > 
> > I would find it easier to read to keep the update in sync with
> > memcg_uncharge, i.e.
> > 				stock_pages = WRITE_ONCE(stock_pages - MEMCG_STOCK_LOW)
> 
> Sorry I am not sure I understand your suggestion. The WRITE_ONCE() is throwing
> me off.

Sorry, brainfarth on my end. I meant to say that stock_pages should be
updated by the uncharged decrement rather than capping it at MEMCG_STOCK_LOW.
So in fact I meant this
				stock_pages = stock_pages - MEMCG_STOCK_LOW;
but then shortcuted it to a nonsense.

> > > +			}
> > >  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> > > -			if (stock_pages > MEMCG_CHARGE_BATCH)
> > > -				drain_stock(stock, i);
> > >  			success = true;
> > >  			break;
> > >  		}
> > > -- 
> > > 2.53.0-Meta
> > 
> > -- 
> > Michal Hocko
> > SUSE Labs

-- 
Michal Hocko
SUSE Labs

