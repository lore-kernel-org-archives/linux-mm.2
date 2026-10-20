Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDFE606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 19:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dRdr2G+b
Received: by kanga.kvack.org (Postfix)
	id 6046C6B017F; Tue, 20 Oct 2026 15:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4AD6B0183; Tue, 20 Oct 2026 15:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9C46B0185; Tue, 20 Oct 2026 15:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 255016B017F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:03:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A15581A037C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:03:41 +0000 (UTC)
X-FDA: 85343928642.10.33D34B5
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id C803A1C000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:03:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dRdr2G+b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792523019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dz9sk4E9ive+ns4UsYhR2kWDOdODtXZD9F+Re5l2VcM=;
	b=dGd1EeA+TvyfKr+sD9uSb3iyyPXbS3Z+TETK9mXz/zH2jM/RHkEgQou5B4tKUqx40qglew
	IpWBYTDGRLlm8W/1LMKle3vCb+64/JcSz0yTa9GeE1NcPgumE7f5zZ3XO5zH1ewn5vgAzs
	IbwTpflw/BLBXR0P1rtMFVSylJHjxsg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dRdr2G+b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792523019;
	b=rlZEZHTGETjsq99kSNVMPtT9sTAZPbbZQzfL1uogz88tNezEtxf5bPacFneJZxD4haLKXe
	lZ55sMCLmWWad2+XuWXgVMBsR8+QYXM/9DUue7GLZSnO8qB7rEC95fpkAbbwkWHBISsLjg
	JDvVrtmM7FjHC28Ayl+e61cgicLKs9w=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b10d24345dso20800897b3.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792523019; x=1793127819; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dz9sk4E9ive+ns4UsYhR2kWDOdODtXZD9F+Re5l2VcM=;
        b=dRdr2G+buMURUFF3137gTdze7rSfo/M4T4AnMfEHkWKcjAH6yzTUWzrSMIUoZSyk0r
         vb0b1udDHWT24h7rXRCp0RAth4JurxR9FOgL48WPsCmQUsROs/qRUJU/nBmheApxnDis
         N5hp/5flz0/5XMZhnrNw30fZohsVCDm2EhZmDPH4jtyjMBnfXsxNuWx1fjMH5l18uQC0
         nt44dPAr/ZviB9nwwOKkS5gIV0SqU0JqX9Shf7mEBo3a8C4y74isqs0PC1KhX/aOScom
         GrcJEbSUuF4f5Hqz3qgOoDqyMiPkPWo1ZjXk3hADLTkpGeINw42MV9nHd+4vPt1rCBda
         KlEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792523019; x=1793127819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dz9sk4E9ive+ns4UsYhR2kWDOdODtXZD9F+Re5l2VcM=;
        b=YZ1X7KNHUYNGS/Vj3h26NpUBecwiKaC2oytNfsofcX8LjVFemJk0DPe02oHDSv/lHb
         WsCxetJHwNQKpH4kiSauy5U4O3I+dHdo/NDhtNBS5D+OMWS+Lor8fz1U5r5hL1zqve8X
         ZO+3ekVklsxDY++yWEdjbmA6XVRwXsrNmkmMGAivmbsR1DKhC0RyZaRCLTJBH+tUZpgZ
         Taa4XJ0N2XPtgtUCi4kEgNDjMBueQKnH3hxGjhhQM8H99303roHSw8+bn8VNZgs0PPHd
         +3xB4cgc5R3btmkZBwPTlKNTs4It6d+f+Xo8KaNOi5RHgT3fq5Qkb+YW0yD/lGEQM5Ac
         p7Yw==
X-Forwarded-Encrypted: i=1; AKwUvBzGbjlAAsf2wg6qMTcSQFrT/WzRpXdleSpsoyyPOESnzftWQo2PLb/0DHps8QJOlvxr9yPpaHaF1Q==@kvack.org
X-Gm-Message-State: AFq9FYLYqTPtDYaBDas0chK0wUDfZzCBnez5m55k08zaDL7eo0GBea/d
	k19FX9HXvVRY+mZKalQcf9YSA9hZDBAt2YnfgGQndazBeI2lVngviQKu
X-Gm-Gg: AYBFou2FswjaRiYQPP+gzveAXyX8OBypAJd75zOWVl3xOaVZCsZFPKEg0RABqp598Id
	e1ii0Ycqo2ix0Og/cEPzsNzVCY1As0LDAZ4iGMKo0B8MOzuK4bIzpEM8d9VY9y5w13d3HRaH50t
	Vm+3KoLSWpTjTl0lEmyF+i4cKkGKEPSE9dE3AECZHx9K1QjKBo5A8X9sRU+tdmJvBTSP/ETfUI5
	vdj/SWlkbaS/GO6+44TK1ZelNPPHbFZ0APXMz1CftkNfPAoo0k1yUhJ/EN+s0HOrmzagoQx4tKV
	NNOzOEQIV8bWFYY/VR0Hxm3aWGTmfO+kAo+5SH6zlY+0J+o/l8RUnWc8duRDvjPSW45PULbTANG
	e/N5+Lc+mz4sxGm4uBtuLKibSbK+pZN3RI/LgiI+PhjLK8lq453BSRN030tZsfkQrN9G/nOrCLs
	0D33aVPXKzA3SXrCMAwvFrP2X3aXNJf6Y/W4tLCSdnc76040QivqLsr64HCi35Lm51BWA5DF6j3
	d9qVCgxpAnCNXO29qM5Cld3vLl0
X-Received: by 2002:a05:690c:4513:b0:891:c494:1a99 with SMTP id 00721157ae682-8b0f2170891mr45756487b3.24.1792523018791;
        Tue, 20 Oct 2026 12:03:38 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:9::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b13016fce2sm1798577b3.40.2026.10.20.12.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 12:03:38 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: publish null pointer before dropping css reference
Date: Tue, 20 Oct 2026 12:03:36 -0700
Message-ID: <20261020190336.3754557-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ateuS_d6hRKFFeZW@linux.dev>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C803A1C000B
X-Stat-Signature: rz8yh8sqdikzhob76tno7am7fm9hypq7
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792523019-631630
X-HE-Meta: U2FsdGVkX18bdVDMFX7MV8AjO0cyzM+BDWqXuiqAgjAE/0Kyv38Ip9zzM7vJWOopdNyAusfb98DP67hLzPjZJSMRX78fjdts8jChqspTSOyr8aMD3Iq9fT5HOS51pXF9v8MRRTWtEp71C9bgfTWdTfp/BRgigDkxcjynew56DWDW9Ps4PUVzrm8oZ0h8DJCPAa7IqjAesSP2QD7T4t/RxrXKl0n0KBSlbiHG1aI37egbVo3WpEgijd3DNIUBuxkwIUmT8dM6j7ihSHYTR9qsYTjwEEKry8+4WUChumyfFRDJakDWIdSsZB7MTnhLAXCowQHyvh5Bxez/HWK/HF9T4AmLZIl8RvWNmUrakLVw14BXR6zstUweSJP5Bsm2HgCKH1et6iwhGTjTB0BAQq0j/QsGjTrBbzVsBr9ZiMGL4GYB/wVkXGPXpIrajrdu7nNWI3QHZth1U3Llxl2mUddjiEdZhflXkVKgQOF0wVUKGcSE6H7pUQpVxraKnx6AT1KKyiPGnwsdEOn8RYjw4sa2hNe8iFq9FqJlJ0NVlPxyay/jo6OceyAnqtSg2MzCqr5zxX0BcVNqJtha8L77sAATOVeZHqrpUEzL8adIx+eF94Pb8nBCNRcAGgE3bEBovbIa0VTEnbvVUysROPOx66XD1lmqjr7L17b3Vu5Z2d5UBq6bhRrl5WjbcRc18/E5i22PMjECubVI3kEkNUSwiezno1YExULN7F5or6U5YG4rE6EZP+rgMo4cPetcvLRtuf0JQ5BW/sscY7/wKch7F5HmiBggO7dVxg83BOsxDtLZY7PFot28wVOMf+sEuMI5tPN4QTDncKHnHHXoUa29e+Sj7fM3OoRKt5ZaQnJZ5dH1VdHvO9MST5fD/+0u22Pv4iMWllPTvVtWJF5sCUNt+1n1AS2kxB4yCqCIrnIgr/k1Fqpw8QxICKyDDsVarX9v0b7pm10cHINbgRututCZ1Fo
 aZnk9rzK
 4lqIvyG93+Nun4VaHtTAP2W9TA7JsWC7MYVy2IxGJtEoIxqRqv0sokh28tM+3zxyNSGd7hbK2DJNIN1j28PAKWDl+klWqQtfyvnd8bP1F1yBd/uh+ydXsK2l3QEn6QPFuvhBHa0aIXZUV46d90lQXGBAPXxLbCJRjvS9zuv/bkxua1D/HtueroJERVgG30DNjsw8bdbpMov1daRZuJR+7gDrYcm3oaYZHWMZN+sF9BORwSaQh03iGv4JB3U4NRXUeGIV+u36Sca9jM14A8LZMyX+RN2Lg9THmixknx0vTwYypvJpdRJAEnrnnDrB9NnYsOI4JH7EtVopaFfM/NTKcb7qA78weQv2nVr3m0IdTc3dse6qvo5a4ksAFos9qYSVZHauE21q/QQ+56vV5+6LAGnmhd7twcHHJLYVAUn0B4vPdq9TB/IZv4hRVXVgH0FEMDQRlpx+FQvMCUaZ3oEzfcBxWdzDdvsKvhkw6kkHRcDPhiBNVhtZXVLn3R7ggiAziLhDHgsOHsu9a2AEvnkQuiamnDfFSHCCeiOn0N3o2Net7RuKZj4JXkhoO6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 11:13:27 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Tue, Oct 20, 2026 at 09:56:26AM -0700, Joshua Hahn wrote:
> > struct memcg_stock_pcp hold references to cgroups that it tracks to make
> > sure that the memcg never gets freed with unaccounted charges still
> > living in the stock. The cached stock can be cleared either via
> > drain_stock() or consume_stock(), which drop the reference if the
> > stock goes to 0, and then clears the pointer from the stock.
> > 
> > If that was the last reference, the memcg is freed after an RCU grace
> > period, but this can happen while the pointer still points to the
> > to-be-freed memcg. Then a reader that enters its read-side critical
> > section after the grace period has started is not waited for, and then
> > can dereference it after the memcg gets freed.

Hi Shakeel,

Thank you for the very quick review! : -D

> These are per-cpu fields and are accessed within local_lock. How can there be a
> reader where a cpu is still between css_put and WRITE_ONCE and within
> local_lock?

I think there is a case where a different CPU can actually access the
percpu stock. drain_all_stock walks every online CPU's memcg_stock
and calls is_memcg_drain_needed, which reads the value with READ_ONCE
with no local_lock. So I think there can be a concurrent reader that
doesn't need the local lock. 
 
> > In practice, this is very rare and I have not been able to reproduce
> > the issue in my own testing.
> > 
> > Switch the order of the reference drop and the publishing so that
> > we first publish the NULL pointer, then drop the reference.
> > 
> > This is based on a report from Sashiko, who found this pre-existing
> > issue in my page_counter_stock series [1].
> > 
> > [1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com
> > 
> > Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  mm/memcontrol.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index e7d7db5718f9a..a05d9a8baa1b6 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2172,8 +2172,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> >  			stock_pages -= nr_pages;
> >  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> >  			if (!stock_pages) {
> > -				css_put(&memcg->css);
> >  				WRITE_ONCE(stock->cached[i], NULL);
> > +				css_put(&memcg->css);
> 
> This css_put can not be the last reference for the memcg from this path as the
> caller of consume_stock() (above the stack) should be holding a reference to the
> memcg.

Ah right, that's true!

> >  			}
> >  			ret = true;
> >  		}
> > @@ -2209,8 +2209,8 @@ static void drain_stock(struct memcg_stock_pcp *stock, int i)
> >  		WRITE_ONCE(stock->nr_pages[i], 0);
> >  	}
> >  
> > -	css_put(&old->css);
> >  	WRITE_ONCE(stock->cached[i], NULL);
> > +	css_put(&old->css);
> 
> Here this can be last reference but I don't see any concurrent readers of stock.

So for drain_local_memcg_stock I agree, since FLUSHING_CACHED_CHARGE
is set, so you can't have it concurrent with drain_all_stock since it
will skip that stock. But refill_stock also calls drain_stock when
it evicts the slot but the flag isn't set, so is_memcg_drain_needed
can read it at the same time.

What do you think I should do? I think reordering makes the intent more
obvious and maybe it's just me but I did find it a bit misleading at
first that we were dropping the reference and then publishing. 

Thanks again Shakeel. Have a great day!!
Joshua

