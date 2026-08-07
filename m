Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F67FC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9F26B0088; Fri,  7 Aug 2026 16:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABCA6B008A; Fri,  7 Aug 2026 16:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99426B008C; Fri,  7 Aug 2026 16:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92C526B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:07:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 233ADC01CA
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:07:39 +0000 (UTC)
X-FDA: 85075558638.05.0D5FE43
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf30.hostedemail.com (Postfix) with ESMTP id E4AD580010
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:07:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786133256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/MJr6Oe7Mwi0NIRhRgjfbHGJr7/OP8f2gsXk/Z1AZs=;
	b=XoaHKJ2s3iDgqFEyMiAoYBKkSdF+3urIOSZJJ79HlVJ2Am2QSeQIHxcZOS9guN2rbqJjY6
	Bb/Mc8aYIbjbCMcayaEQ6qqw3+zWJHmhiUbtgfGkHBLn+3kBYUBkMzi3dXICLgJ6dr7Sm+
	wbJ7SVr7NjQECDL9AwPCjCBgB7GTywA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786133256;
	b=JyrEHDK+WCwAhvTlx4iZBLMOMrE/EDzDUvCrW2EUEccfuki2pqHbofOrknL0ne9bfchjQ8
	O1WCmNQfYfFWzcgOLYhSl9sbSiNeb8f9agvRfxTq9wg0dd8Bqa3twfADtGr7UnZTw/N+pj
	VLUGgwxsKUMJ5Y2DsKqr9f4ti/thBTk=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7EA5D801BD
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:07:36 +0000 (UTC)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49D3C1401C1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:07:36 +0000 (UTC)
X-FDA: 85075558512.01.904E047
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3CFA840005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:07:34 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786133254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/MJr6Oe7Mwi0NIRhRgjfbHGJr7/OP8f2gsXk/Z1AZs=;
	b=hUcN4i0+9g1Ko+lvtTs3GpCQIpekj8llVPGQLR9DoKd/VHelphfF14HHpzB3lIlnq5mQjx
	vyWtJ3Pj2f6QciHbG1SvGUpIzJFrZRtGWoS+RKBbRI3sMq8NtL0FWwE1AI4NgCCKsjgvkV
	aQ8awwAJJX36c27BhYW5v+90fpPDPEk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786133254;
	b=xktIuNwE/UujuBNHG9x8uKhjwqDioIJBhTgzO2OtkdeY3h0X9U+VDQ/76Dgk5eJMxFJr0x
	iJrtvWB1nHJ++IgkB4snEAOmVNMpJAEeoUCvyi2lWe5hO4HxBoKW6R3ZNGxLvPQvYk2/td
	SBjurak9H19GZJ/TLww7wiFHF5PQJMc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SxhZj1R8;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4955de8797cso26800335e9.3
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786133253; x=1786738053; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d/MJr6Oe7Mwi0NIRhRgjfbHGJr7/OP8f2gsXk/Z1AZs=;
        b=SxhZj1R8RCDdo2xBV8UF7FqMXEYzazyuFOr27FaZxUTLzOFb+D8uPJ6ovRXNiPurI+
         rMGJq6LULLqUYd+vYY8I0Y4LbAfhZn68JDog3cVozCeYqLWMogl3nb0r/AGi4b66REPd
         qtWZ8ylJFQCRFcuW+nQ3Q1Vl8rz2XCbxnZUIHDWcLt3PYjBGiuHwlxvebZF5UoLpFGD7
         ZT4KLqR+pxcp9PqiHytm9b2++RXA1MoMkc8hkB7FKtBgOwpsHybczHYIsedvRyhO3hAa
         wrLa13SKPZ52Gut5qf5AWXyC/meqGOS7B0jBTz43oJBsPp9B1Phqsa8Ah46F/mrTKlTX
         8nFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786133253; x=1786738053;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d/MJr6Oe7Mwi0NIRhRgjfbHGJr7/OP8f2gsXk/Z1AZs=;
        b=nTwHI9VQZhdzd89ozLVxBpJE0WbzgMdNt176IME2Kgi+c2bBTR9OMAVSRCV5G3L1wn
         yw0tY5lty5Kveuc5GaqiSMdGcVocfe/ivK0FOwq0uW+lLBGgsRtkokHod5dkX/imL6b4
         8deE7WP2dhxYQ4PTwWSc/y83PKjv1JmX0DCqFsF8GgJsUlx4z3do51MJJPamU/aJOMS9
         NlNPweF5IKwE7dzVHAXTFZWDFrC5L5BPAbcAArCN8/d+9RDJ8BcVvwu1r6Tx0DKgYmzt
         4FVQs0IhTvC0GISAeuZcC891t2/RaCRu6FFrxc7iN8sX0FEAUyQjVhOLUC3F8RlkmTwu
         zeLQ==
X-Forwarded-Encrypted: i=1; AHgh+Rryfebs1E/NAshtfNvl/cIrOkZlIngQPKfm1sVZQ4oZVxX5cL7Hns+eE/AOLdzPQz99+h0XXVvNNQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+QgVrUsacsHOBbkEeS0JPPBqD7RLYIOnhYdcnCaSRMy/x6GiA
	EDF6jytfg7HWS83RetfUdWC0smUkdm40pl4sgjranp1HME44pkr6TYlBy7tTUAqRxnU=
X-Gm-Gg: AR+sD138YrYnDJBRrv5ScptJ2YgeBzC0+jrnW9xF6ZiLC5o8l4+gngzUAZqEbYxx0AU
	tF0IfeZ7MNxhz4HXYzs0jKNClkf2ePDnNZWhAF254QsX/nJjHsXIjx/G+TNRrfRALjQQ446MFoU
	V1uneG1+oBSLXA+DSJLt5lwrrvMUv1zodXa1HBDgzyL8vTR604BZPY4aXj85iDMMkwlji7DImcY
	Q89NxNuyXxg1ekqiaUUPHpEuFyxnZAllGQJ2WJcSuJJSQ2jo25PX/MuKHxEFAXglPrguNLfFDEN
	t0Aq5KLwZGMRDHE3o23gMh1aAq4cV8QGsWKs+OAdfpANQLb/f8rGvUWwpKdBngRtYqxrSg8p691
	YFN7n3CjsKVHPzOTM/8N2cDciCxgsCV2o/+xXLLDsR8S7YgANtlllli1b0G5u2kxQvFgF+Jb48g
	VUsMOdLt/EAg4zFJFrNF790VGs4c2uC8z98GRC3tMem+x0GAcRVhvwGwdpstYn8GfREOJ1ufyEP
	gTxbLkP4TLD
X-Received: by 2002:a05:600c:b85:b0:496:c93d:e2f with SMTP id 5b1f17b1804b1-4995e0dff0amr84684845e9.15.1786133252699;
        Fri, 07 Aug 2026 13:07:32 -0700 (PDT)
Received: from localhost (109-81-83-166.rct.o2.cz. [109.81.83.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021fd392sm8251138f8f.31.2026.08.07.13.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:07:32 -0700 (PDT)
Date: Fri, 7 Aug 2026 22:07:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: Audra Mitchell <audra@redhat.com>
Cc: david@kernel.org, jocolema@redhat.com, raquini@redhat.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anY7AnkL1WktYbVW@tiehlicka>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
 <anX8VgySSw5OR_Sb@fedora>
 <anYoLs1B0MwUNR2n@tiehlicka>
 <anYuUpgvsUGZcGMQ@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anYuUpgvsUGZcGMQ@fedora>
X-HE-Meta: U2FsdGVkX19SoqOLgNyAk7IIMjgMYRv9mGsVKtEXO3s3gMrb8PUe0iZn0pkTNwx/87BfvkvLN3Bdf/KDbvYLQCzolH0h0NVMMLf5ZpfhbHjsYE9ON+PxgEo+eqOk7LeG/GbbKAXYC6fHKtR82JLtYJndD4a508fL13WJydF3yRShyqdRuayPoN8K/TYKFvSFQILTD/+iQzy7N2m0fZJQdmVXGgFglaBERveI10IH4jZZbHbqWKaSQcDivZ5n/Idpj4pV1AeVeps43R+bMGPXg9EZHNWbxaN9hHXbfdXq0SdH2clHj1jP5sw6wWmYrvHiS0Oi5IJwy3HyoEDkkBUCx0gnNg7jrzATczoDQfCdYcCbFOxS6JAx2ANsT5Qnnno9SRySFaTxCnoV7UFLhFGVsXOQR2UsVym8h+zEGPfVcoF2a8ajOiuTtfYl6n+xVAj9ZJzO72hmf7PDpdHGvHalZivjLPjVDo4zRoo54DczSEVy13h7a/xBa/qolfE+iuC0iytsymYjTKiy/t134c6PNUWo2GoFevdym5wW3Ip8LNt9l2P0vGax6JyJx279/OyDYdMA6kwM0E6cIrGA2lG8RHD57LnxBYcZ9dEGFKlyp/Cp0g7IMlYr9bSPPE9O+GkhJiJ4034AvLT9LxyX4eJ1tiIVhnacJDWcf5KLwT/3fAh0y95qwclPUQeFqooLu1eAFHSsC8dJLDoAZ8i4WVu6m5DC7Dv/TwasY3M7It8LguITLr153aDGtC0SPU/rlWmUxnKjJy2RlViTSIISdRM7tUJT2FlhWkhAyEPC2BZsWx1g8IWTyCMrAbSvoISOUU+FGXLkT+x1lY9MTtJNG3fkLFrycU775zwz7KhQ0eB2syCaik7T+HwYyLj4aKz1gYosKzDCEMFKbIUBMnmSLe2qNL9HDH7bulvlMQTymMaiyBb1pAVXI8cdloAbfTLcHQUWVXkfRxUc/an2NU6n7+y
 5LqZ0+xA
 yAT5Lv1s2uZjN7uyZ7Nm4OPkrjHx9DcUJrxl5SFuQSpVG1ZXDDb8HQoik8RijfvbgsgpQOM4IsIb9tSJGrTvosG5tqobPMDedAi/3n3/6OxyEJEidVqBGv833VLTvHJ1FqFWMhWoomFVEA/1vMcayJeiTSXecvsA9pVYanY6JNCzadgzdT89AZSwqD8Px3J/f9KAPSDYEAjn1ULnDLxCzBgXsoBMk1tbQrNmrfqV3SmRkMygvPTMyU9wZ2d9Q+qcUTVvRH+MKCyf7Uece8TnBWWjJ4dEC7vLjDgIuZXfAAA8grJlEaICHZhojRs4yfciR9hjZbn1mBsSljMTYVHfuYN0QCVe5a2RYw10FVjGDOKbg1/nRpS1XnniKOb7LFTHU0tIFdrGrFCCqCumR8giDjcfeyA==
X-Rspamd-Queue-Id: E4AD580010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wuzhg3tzw8j5i4yuirjkppmw4pm43dnk
X-HE-Tag-Orig: 1786133254-26338
X-HE-Tag: 1786133256-103768
X-HE-Meta: U2FsdGVkX1+HIDBezwuchwUsNXuwpHVSxD2XlawQjHtit1OgVkFq1W0yGUgvhEc1fIeQbCemT9nrAbm47Py7ojUiwWJR/vDd/t2HwW8EcGyNqLKj+kX9sTXU8cDLAiU2P0tuW+3zuMCE5LwTnUJ67B8gpBEbgiu0FAtRx0OZqxzVJEX01/mjC78HxZdtf5yX3zr+zXVsNp5VZ36rTk1CNhflbyrWGL85uGmMmxqE40Qk3XxzBZ8WiocTiZvwksO+YWFZ4Vfeu96gqFfl9QilMjMbAiQYHxuVwR3Bg+2hL4gkN+cpcsYzqkRLoXM0W80OT15yYHu5/KUVjCdOH6RREtmuSKxMBd1OjXWzuURb+37vISVdnFaKdGZ6X1a04UWYhczSiz8NP0irYNqQp1f8z+T+sVQtDIwK/Uv3ympuVv03nMLr4wHqLg7ow73Rk8nFjjeh1fxDD0vvcTavDW13DE+S3ZWKlBTkhGSyNo9Ok06OZGIvy4KJZgL7fHTwlGuVVJjuzVBh4y7kJR740eIBXA9gLflBUOw7E+4ND1dLfhKItsWnABHNoS6g1U7UpleMwBD0mmENXJOsLeAczbReUBDGsHzSCLZn+Flx+kIIblMfJiY9DJAv8+tQoXkKEZfrgjkJTyQ+VgIvwk8ferGQK3n24bqSqGKhVqeF2vL0yk8A8Vbq5VB4JHKgsM4rvjIDkGedD31Cv3ES99Ih6LF1AM9ZlcuCZShwsWHOSCwUf/ttowl9lhsKMAfgbALZ5dSGvQEQEcFlX7ukiQK7WbE5CrIJtfkECYg3VFgg1FblYWd1hbvrEATZ/93+VVg3HmrX9eCoaFuMLjmFXIiDDA+9FjP3BOZGEvfO45wJiocu/QLiJxpIff42plfS3iNNUNKnXc5WLw9B+SgrNF0YH9SKBY5XkQ0pYsTMGriSd83P80Qu6CvfNGN8bDkmQODQI+Ig9j6MyYCCUuSpQhT4DK9
 0UDD9OHV
 UQO1jAb4kih2t5KOJ1PvATAmYUQB4csz6dsLwtXjUB4eRvPP56mT1hiPC5PQXdSdgJmVf9CWgx92Vaq9zZvt6G+0ShbM2ZyrEEoIFe+b/l6rA/TJrSGNuK06BC+2bQqVNHVoARlcehpkoTJeYcNJZ6jeX5Tav59BtBzl0yg4UDAegSIchWv2ROgXhP6bqvAb00/IUokHiX/a93V1NkbyMvmrH3Q/9l8gVFcNxvxUEHDQ2AKna4XtgUiU8bihE45emWeEeSFutPpovI2IiJG5mLK2sqIsNm23HVabSNgeeURGaMJFF0/a9cBNLBcbdCHRFUtJH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 07-08-26 15:13:22, Audra Mitchell wrote:
> On Fri, Aug 07, 2026 at 08:47:10PM +0200, Michal Hocko wrote:
> > On Fri 07-08-26 11:40:06, Audra Mitchell wrote:
> > > On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> > > > On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> > 
> > Well, both global and memcg reclaim share the reclaim logic. Both of
> > them try to exercise all reclaim priorities (i.e. check whole eligible
> > LRU lists) and they fall back to OOM killer only if there is no other
> > option left. For the global case should_reclaim_retry is the gate keeper
> > around direct reclaim retries while for the memcg we have more or less
> > fixed number of retries.
> 
> > From what you are describing above those users might be hitting reclaim trashing.
> > I.e. last small portion of a reclaimable memory is bounced back and
> > forth for the workload to make tiny but steady forward progress. While
> > OOM killer might help to stop the suffering and restart the workload
> > sooner I would generally recommend revisiting limits set for the
> > particular workload. Especially if restarting it might lead to the same
> > state sooner or later. Watching PSI metric would be a good start to see
> > how the workload behaves wrt memory stalling. User space oom handlers
> > might be a proper measure as well but that will always be safeguard
> > rather than a solution.
> 
> Both of these recommendations were made to the end customer, with a
> significant emphasis on reviewing the workload and the limits in place.
> 
> However, while reviewing the code, I was truly surprised to find retry
> pathways in try_charge_memcg that do not decrement the counter, such as this:
> 
>         nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
>                                                     gfp_mask, reclaim_options, NULL);
>         psi_memstall_leave(&pflags);
> 
>         if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
>                 goto retry;
> 
> If the intent is to have a counter of nr_retries, I am genuinely surprised
> we are comfortable not adhering to said counter.

The said counter is conuting retries without any real progress.
Similarly to the global reclaim. If we get some margin here we are
making progress so we are not really OOM yet.

> The patch is not meant to
> change any heuristic, but only enforce a counter that is already in place.

It is very much chaning the heuristic ;) With your proposed change we
would be hitting OOM much more eaiser and often. Not something a lot of
user would appreciate.
-- 
Michal Hocko
SUSE Labs


