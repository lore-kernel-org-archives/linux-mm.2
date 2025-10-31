Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A2BCCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 16:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7572C8E00C6; Fri, 31 Oct 2025 12:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E578E0068; Fri, 31 Oct 2025 12:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644998E00C6; Fri, 31 Oct 2025 12:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5437E8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 12:49:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D121E88865
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:48:59 +0000 (UTC)
X-FDA: 84058993998.21.6A67009
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id E340380004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:48:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CLacUXi9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761929338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lgb+9C3jvqIAil5vMaPqTfTmFra5MOD9hf+0ALcR1eE=;
	b=JatS1sk0KXR3R7VWarAfH1iGeIAzjZDu7cKKmgXHodA/do4zPlrUrnWaRq2e8Az9jdpGZg
	StD/QRMNlKI0MzZ0O7gnaakENfX7pDfNCNpG0ap3gd++29AZwJeCGPrPc8T9MfDS+5IzlM
	GwHYY4UKcMwjhjh33b77OtWlPYQxjeI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CLacUXi9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761929338; a=rsa-sha256;
	cv=none;
	b=a1q6TswqM/diALNs8+hhZPk5lMI0Xr1z9CKtzFMNQdNs+omLt48uqmOAsplOl1TxUCUr+3
	vK0WNZevLg/QTiqkt1zG3kdq44Bmo+cnNwZPDXP253xguUs/jtZBJZ7KJCcGT7Xg6OfyuL
	fJtrDgfTxEpqUXTOD7kLREFiV43r0cI=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77f5d497692so3225714b3a.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761929336; x=1762534136; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lgb+9C3jvqIAil5vMaPqTfTmFra5MOD9hf+0ALcR1eE=;
        b=CLacUXi9Uf5FSEpWps9SGGZtEtobvPYmiBc8k+AAJKs1AbxFSZK0PDWHhHuylpsueY
         HKcR0ajEnEVp3UHzyuoAnZF5xTO4CvKl2zHdYpW7DC28P+51C4Jov9HltQC2VpEcRbz3
         A7QhTCOmKNCtI+MwAl1MGrFOzjc4fGh4NOwgS9byLJS9+EpercJzSpuKSvPX1xRnI7i3
         KOtTAOre9c9bwI3kDL+TcQPkH2jlZo7wsU1ywV/8btaf0xLBfN9v11gyTsIhUa4xuA6o
         BguqgVVa/GZ4ua6cD98vB0fsFt06P1e6WlCNyZSHxU69vjhoCJ5DVPdjCkdKVgdhzOa4
         TWSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761929336; x=1762534136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lgb+9C3jvqIAil5vMaPqTfTmFra5MOD9hf+0ALcR1eE=;
        b=PcGSZq5TXvOPTftM6+4EWgmWRFo52KOdRZikKqpxxDn2Xz1+rjn8TIAvUV3MY69qKm
         Expp6nH3kEOZd4AZzACGmi9j8Ov4YYvQ1nDD90mUjHukEgEYokPIGHNIiHcDZ5gy5sfa
         fc+1pN/2CIWAaJLoe5vfiAJFqhsWT0JHSOqM0WI2R4HGiYd+IYdH1SgbDwvPv/Dvx1xF
         Qj/+0gnxXFLn5NguRmq/uEsH3aPpx1xIp8rN90fp8CnwF8uh2d+P1n6zxgVtSHcBz5Ni
         GloX/lhanYG403LnUg1MUZRxBt6SycQzXuX6vkt6mDW7mN/ZWcmtq3oBZ2/iab/xNs/I
         Qr2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWkAbOSt6QTgv1Z8mKn1DZO5BtYcS4V3bpf+o8bPJOJhVe649nZ9nQz2LGy5hW9HGi4IL98kRjdMQ==@kvack.org
X-Gm-Message-State: AOJu0Yzsmpx5pfUxW658FUmonQ1hzSJZXSuCP1DGsTDR0e3zhzXdxs9h
	W87T1aeavRblVJCCqBqYGnOGUrVxhzrqrOH1ViCAI0qTpnDnsFr3wcyx
X-Gm-Gg: ASbGncumfYZxvQJcuiwO0EaHL9L2IfN6yoAmkH0lj88F86D10QWjYEkyh6mayOTbUWg
	bGubOMWZqtausyNdat4bcbThhfcB2nzaMqIPSRvA3G9Nf5ZBaFCQRx+qHARY48kRz3MnBVfu1R/
	V/b91UaSX1yKQ6kSl/WqQ+1SuYhOqXBenZ4iXEwCoKrYHZcseBJ51UlF3btL9L+oaVcKYrlUBso
	qdMmfvcV4xVp30WLsYi/10nXse8HkS7PDbBnmenQWeQSVck/OkVhx35LKZJ4xOiChQI/XBrqtco
	LEhOW+COmUkPz09K2S6uXnijvhZLtBKpSzU853qfRGS9mOxfaijalx/MNpF/b/aLYHUwML5V7uP
	bVUfXa6BTXZEjwu/+YKT3sJe/SyAadSyTkcQV24BkqaQzOnJtsQmhah48INHAw/t0vJHAxblpj0
	TvXaDGIvg0aN4eC9Mtesk0
X-Google-Smtp-Source: AGHT+IHzisb8pOTUrWEeEIlE11gPDxItgXXojG7g9LRH0MLHpSQGT5VIV7jL+XPyT0+qo+/zJb0lZA==
X-Received: by 2002:a05:6a00:9291:b0:79a:905a:8956 with SMTP id d2e1a72fcca58-7a77718e95cmr5394654b3a.14.1761929336301;
        Fri, 31 Oct 2025 09:48:56 -0700 (PDT)
Received: from localhost.localdomain ([124.156.216.125])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7db0a26f2sm2755863b3a.41.2025.10.31.09.48.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 31 Oct 2025 09:48:55 -0700 (PDT)
From: Lance Yang <ioworker0@gmail.com>
To: mhocko@suse.com
Cc: akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	inwardvessel@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	martin.lau@kernel.org,
	memxor@gmail.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	song@kernel.org,
	surenb@google.com,
	tj@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 00/23] mm: BPF OOM
Date: Sat,  1 Nov 2025 00:48:44 +0800
Message-ID: <20251031164844.27060-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <aQSB-BgjKmSkrSO7@tiehlicka>
References: <aQSB-BgjKmSkrSO7@tiehlicka>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E340380004
X-Rspamd-Server: rspam03
X-Stat-Signature: ioqqk9h9b3hs6qks5j9sn1634ien7m57
X-HE-Tag: 1761929337-955249
X-HE-Meta: U2FsdGVkX1/7IGmHaqgGjw7OG9m+PmXpIWN5jIEmkWRBLa9gkQ99I7DAtvM3yKE3u+crczUouP1jU5d9jaYBF9y2jj+jRg4MJMr/2Son6Pc2jIY4mW0encK6kMjL+iheB0ass9RGhewFtzWnYU3wFsEnlrCzQ4PTD7z84pxJR3I2x/hXCLgJqOTdxrXFMHfL1ySyClyPtCOZW6G1/HIKo7Nzy7O4FoTZPa4iAx/FxAdUEsM02reJ9k1XjFnZt0kD81hUqp5CQD1F0/HpVpolzpcSaiL2aQT1IJDnbbjXym1Cbv9lUUZTh8WkFc09+ZGUCBZtv13K7g+I+q6JDIGv9FLbFzr3kJCOV/7XVPytPqD1lUvzhWbMgSlzdB2sGEiMIvI2Ikz/B+KDAfwNWXZfRTRyOlm3WBPTN9SL/xNXJiEmq2XY+p0t9i9BjvwBk31zpVDZpWfdrZNPSGw+BTmwL5F60b3cHuXvCfYM8dzcsehCLSSGgqh+tl3irwISVmd/6nU2cd+Ds9aT3tSdy2xnRSKmFain03CwpyvW9Ae6ci1mKzdYDi8xCGQC91YnfIrtya0xSFjCT4CcWRioQz3gloRBaTdB/KU7/aC96RtHieSBRvVa9+9RsHiVITZep30zyIbnOcU/957/501OZ2cFDKjVFlpOhsxOe+JYc+bqSxxi2oDHQ5eBRtGAHtrA/Ib7j/1eUe00cxqRmDZMWzmhMGlTE9Wh6KhIaZlmVUIuLVOVWgKEru4E9MO3/F6BRI/u4Jq8apmAf43eZlk2kNfSaz+B1HvGWAOOOryFSHH5yNly54Nwz0Hh8jFnGbdR2MFJHHSA1pJKX39I23vNjg+l0NeLYtEOcYviJ5gbwdd48tyIZbCWoXzAp5rJ94WN9SokhQN/yzMH7boYQMh67qGEKO+Ng5abnRgW0TqEpB2Kd1nWKQ8s4oIiZi4T7gCmLIMBYmLmkoBvfwSyTEybZ9O
 65zeLhwS
 zzs8yRtfk7KrIMRQdmJWjPinxlm46UlASy+pNwHn6qzfMgyQc+ub2kgQoPmir8HITjFYBCUuPV3nhatamaIwX+6vvh9zdvhLa4Qi2dZQMWPKDeyYhvjF7D7RaaiQTtwU5NcuPOxppmjjPdJC3cmJJM36rkD03XGaA72wI4Xfg3WqqW8bgnRaX3ccCRVNFISOv+qogjsSEec3cLyXcm4VTzQWUqVHcN+b08qQWznEcZJ8x97stERgyRxbOQSCUYqtWYfAQOFKp/clqSY/dXsfOk9aUcc+UM9fatWk7/MGTblwxusp7yjh/+90xRFUn8r6BNAZq7z0P1sLzxpaLRBKRucC2ytwNYeLu8wiTzRaMhXlrSZ6Y5rNk4V/usplu24Hrg+swGuB9G4B7ckg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Fri, 31 Oct 2025 10:31:36 +0100, Michal Hocko wrote:
> On Mon 27-10-25 16:17:03, Roman Gushchin wrote:
> > The second part is related to the fundamental question on when to
> > declare the OOM event. It's a trade-off between the risk of
> > unnecessary OOM kills and associated work losses and the risk of
> > infinite trashing and effective soft lockups.  In the last few years
> > several PSI-based userspace solutions were developed (e.g. OOMd [3] or
> > systemd-OOMd [4]). The common idea was to use userspace daemons to
> > implement custom OOM logic as well as rely on PSI monitoring to avoid
> > stalls. In this scenario the userspace daemon was supposed to handle
> > the majority of OOMs, while the in-kernel OOM killer worked as the
> > last resort measure to guarantee that the system would never deadlock
> > on the memory. But this approach creates additional infrastructure
> > churn: userspace OOM daemon is a separate entity which needs to be
> > deployed, updated, monitored. A completely different pipeline needs to
> > be built to monitor both types of OOM events and collect associated
> > logs. A userspace daemon is more restricted in terms on what data is
> > available to it. Implementing a daemon which can work reliably under a
> > heavy memory pressure in the system is also tricky.
> 
> I do not see this part addressed in the series. Am I just missing
> something or this will follow up once the initial (plugging to the
> existing OOM handling) is merged?

I noticed that this thread only shows up to patch 10/23. The subsequent
patches (11-23) appear to be missing ...

This might be why we're not seeing the userspace OOM daemon part
addressed. I suspect the relevant code is likely in those subsequent
patches.

Cheers,
Lance

