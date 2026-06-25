Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A891CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69AFA6B0095; Thu, 25 Jun 2026 02:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673586B0096; Thu, 25 Jun 2026 02:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AFE46B009B; Thu, 25 Jun 2026 02:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31E536B0095
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:43:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92B701C3352
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:43:56 +0000 (UTC)
X-FDA: 84917494872.11.00E5D95
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id B8F15140007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:43:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ckb+Cyee;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782369834;
	b=DLZVdLpkQRK9ByCITmim+POHRxQsADCtQtrEjrrAYVKLnYPpVZWtY58p8mSVxURMW9ZvG0
	JUFhQA6A06+VBYaj/APzGPCIoxqj8z4QX8f2/lII1KYUhLvJRvyF9zZzFUd2SZEvZ/sMQJ
	gSGVz4fJIVZcyBVreh+06BdX1Pm1DEk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782369834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAbcZ3NxbmsxcgeRZOVz8olu265ZXR9ZINnNyOlf82k=;
	b=MTeGzoZt4/sIx+WbSdk8zjIyBfbiBa4JWcHlcPNxQ+bXbx7km5Gw18lfP7ai/80O6TZ7As
	o7LtKuH/Cmi9/sdNjIKl+96pt4WBnfonmep9+TKKOI8Qsoj3BlboOiDpX5rOqt/0iKYZlK
	JN1q3Q0t+N02Wwup1r5Uf1ZK4F9X/cY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ckb+Cyee;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-519defad0d9so19205851cf.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782369834; x=1782974634; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZAbcZ3NxbmsxcgeRZOVz8olu265ZXR9ZINnNyOlf82k=;
        b=ckb+CyeeEHkOe4YAGbAkUz2W6ezjYszlc6+jy78id0aXiejYjzkeR79KKeK/vXgJNA
         0EpJeGOd5iZwzbzGxLn+bE1dGbFTw6Ic9SkProDkCxwgCbWadpjOughIVrhzz51AFWvJ
         eatcm5p2TET8lPelRX5pefXAOZIrZkCFA4LD2dxmDlj1IjAXUXnWDkISbLXlp+eWk380
         hnd1AEe+r8ac3H3/ghLmzgt+Bm/yOWzU0lIfnVurwk4Ez8Y0NGB2jdfufC3ExyfVrhQr
         DMsH/DNpelQlKgBAYA9gw07dmsMuq8I+KziaMCyCDBqPA/6KRDGimCw4SG1+FA1lMDdY
         A4/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782369834; x=1782974634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAbcZ3NxbmsxcgeRZOVz8olu265ZXR9ZINnNyOlf82k=;
        b=cbEeMWJeMtI3ZpvFHzPVwDgP1ca0HjyJyUZMCyYV7K97cVFgiC3tOzqiZ6ZnABf3y9
         bTxWAL14ejKQxt5LMaETF4clvD3LM54LUnysGj/MqXIpLNGGUNtEBT5/gOqqk8ZuUH4h
         cTIFUD+HOjX0xYgeema02GN4P2Qfp+kCQsbaRY40+qo9WjZj+K9UzJXBJa1q+MYkuCo9
         d0K1IsarZs9a++JUm4A+9f4n1nBwOxl6rcvXUjzz88QnMG4xE7GMTi77upusQ5MzC7TE
         /mONZM1Hv84t1O9qPaGt6+DLa0PKLTSGH19bFR2ZNwDEO5t2EqeOLazXfDQzhyksTG9M
         olAw==
X-Gm-Message-State: AOJu0YwY/6FgGg4PoXUVzytBx9PobUgXswuJ+yW7yQT/NxXc2JnNXoc/
	b1FkHTe/LUBj3ueI5Q0nbdHdLOIPE21kQHCYXnaNE+UKMCRhyP2WAorvDgiEHQQgHoU=
X-Gm-Gg: AfdE7cmMlToVXuc7G0CM2GT0AbKc8mt6FUQLTNkPQzhIWtczhFl3Ip4hmxyCx29a3jy
	mtCL+aUq5V7dZKlbk2Ut4ktt6vRGV4ByBwkXUhukDR24MV3L7CSO8qCMqVAH4PgS6s2kt+PCqOQ
	kOpHFTKSiMQmmE60nM8QlUhautz6QUvfZb8nqqkdaS+rzn0f1rSR3u9MpoPA8b5xmI5vKQEgvKT
	oS5gdOO8Jg55vUqQApROBFCT5WIe4jWe/nzIn1GscVAVXG566AyEKKw57denl9LqlgAvC8OVNZr
	bSMNpt976Q10ajs3qgSaUOWhlnn4YyJYo4tgYunfRutZh/GhOVxpJO2EBbgAoAGEHXLIteHe3UG
	C1oeqi18UwBaBM/OH8ZJa1OlT3hAP2n26ILMxj2X+qSb3XEA7zo+pJ8cEOug3SQpdCrJSBB1syA
	ddddubWEBuGo0jEIduBh+qB8Hn0Ost2+34LaT9wUTq16v3kQn3GCGsYoEpKyph0TCS/3px
X-Received: by 2002:ac8:5f85:0:b0:517:83e5:7859 with SMTP id d75a77b69052e-51a72a8d81fmr15082801cf.53.1782369833788;
        Wed, 24 Jun 2026 23:43:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df7f015e50sm171495166d6.6.2026.06.24.23.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 23:43:53 -0700 (PDT)
Date: Thu, 25 Jun 2026 02:43:48 -0400
From: Gregory Price <gourry@gourry.net>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
	apopple@nvidia.com
Subject: Re: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <ajzOJPgV1acrUfr4@gourry-fedora-PF4VCD3F>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-9-gourry@gourry.net>
 <8e42587a-d614-4259-ae6b-5bca1479b425@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e42587a-d614-4259-ae6b-5bca1479b425@suse.de>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B8F15140007
X-Rspam-User: 
X-Stat-Signature: qnwnszjtpwqm7u1pino1y9iff1upkkgf
X-HE-Tag: 1782369834-939671
X-HE-Meta: U2FsdGVkX18ZtE8JvcTk5RWuZvYAMXWIzLARB0i3EqKL0Ub+PiBZW0cYy5GmHT1bD7taV3Mw5+EByJIcLmy6fP/qKmFsXCVqHv/YP9Zs0ohDNamWGjS0J5ZSZjtanOKayCB3jygAQcHbDCHlvUMe3szDnTzggB6dKI5ymiWFr79Mq08RZ/eQm4dTFH9Z4eSQmlfRTAcf5oz/NMBeiDhIrK+5nfBd0eXD8VPu7L6P3NAretFEueN2BL/o6wRe/eHQvlrGrCbiKQ5nMWKY18+fI+VqLRpD1HLzLIPbGBzvGCWpuXFSC43JVnvVNOZ1kupOiFXS5d5D4aJyoFko2EXJNfUBvsSqkQHs0XkREjHLTL4xe5loVqs00UmbB82KgVHg54Ubh4Ub7pe0Q6Q59YzGWV933E/Wvm4L942qnm905Boi5C6yAzNe2ZM+zQyHQRrBM1cmmbyaz3LZr8b5LXnoFt/wsl9phVAxesij8JWS3/wh7DiUQxgYwEdeXYs1x512leHxeRhPfzL1KqgtFDKYgWEPdmjCgFJ6vMa+89Krc0iNX9FuAxgGZfYEhll4jVM6FVd8UVXK4JzJFdQzCOTLjMfUDvS9mw5V+JDmwE4tFdBYmoS2XFrEWLjGpQQxF+JnWrCc+zs0qfWh3tIM6sw+S0jNZJgk3L0WaiUKaPN+VorslSueyI3OuHvbhcf+7Bnnf8hr3OPxWTNST3poW/Q/3pBWnfYLbWnlmy6fYFJPS6hIx+iRNDuCS9w/sZAnOcwcL1eJRVdWpty3fvwHzI4AgFs3mfGC+9f4D8puX9JUrWNNHNMz1i1tgYOrSvSFABc9Z9BBNsI+UTN0ob4gFQzvIdbqNHyb2ehs62m5eTrCHsIGGNetRLI1I1sAiJXPNM5HIU/DMLAPa+B7oI7PfHqAyHoqutlDas1VxrXncKg5V2GNFKAyRGzpxQU55ovSiazfYCBEyZz0Qzhvadne8hA
 wkDPwzq8
 fpcR6+lOKbObvuiaNHampFgkqWWNJWB1t4FltFbZJPGUEyKzecaFzfXPBWwYagqiLAY/9wxr1hSdXCSCQsjpr0+BMnZBidXA+bQLr6TCFrORyO5lOWACy5H5qO0ppRUv8jja3+0jFDrDFcnKozlymk0NQhRa8dRQPDID0zJfPz+97N7b/V3NjDAYk1QXxuNDepPeKOA+o7l6c9xj0w1vV26MBaz1JeCnsOy0tM1+bPsCwY/Yv0+kmu4DfuRcAMcmFGKf0VbsrEE0+k7AJVICSVAedMOk1EwmC2FEaA55pDE6zJasb7EDhAxr3KNA09nYPnaJFBsN9r3kUL/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> Why do we need to treat the 'unbind' call as a given thing?
> If we know that we cannot handle online memory during unbind,
> can't we just disallow unbind in that case?

No.  Unbind is a violent operation - unbinds cannot fail, and a
straight, uncoordinated unbind is essentially a `--force` flag:
the admin accepts the risks.

To your point, the admin either does the nice thing are they
muck up the system.

But we should still try to do something sane to defend the kernel,
in this case we should try to prevent that task from becoming
deadlocked.  The only way to do that is to leak the resources.

I'm making a small modification to this code to reinstate the
legacy behavior when "state!=UNPLUGGED".

~Gregory

