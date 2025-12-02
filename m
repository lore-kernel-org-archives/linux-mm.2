Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC530CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 08:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A19C6B0010; Tue,  2 Dec 2025 03:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079BC6B0012; Tue,  2 Dec 2025 03:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8646B0022; Tue,  2 Dec 2025 03:55:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD1496B0010
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 03:55:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B4A2C05A3
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 08:55:23 +0000 (UTC)
X-FDA: 84173922126.29.C41C7A4
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com [209.85.210.65])
	by imf16.hostedemail.com (Postfix) with ESMTP id AA81A18000F
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 08:55:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BW/mBQ2X";
	spf=pass (imf16.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.210.65 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764665721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXSmGRnNXYiolaBmLEqVnw6axmZZPzNuLcO/h/AgF1U=;
	b=BtzztyoxuhvPIdFNEsDJ+7mxWsmqYpkwQUVJ4Y4EgDbrhLNDgGR5gny2n9cnbnODLPEVOa
	czkjWVyX6dwnrFszspC5xfSWOqB+CxKAZ/qK6+U+sx/Ag1aOmkkXJ+0jFmMXl8kuk9nh2j
	4rzGb5HsZFYi6kX+zjJZHy6Q3UhsCJo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764665721; a=rsa-sha256;
	cv=none;
	b=pTjd/WrjM0xWoNU2iY/a2cmamdSUDvScO16qYkVjlTgnF64F9ZEu6UiW/qvllkqfrqLNNv
	vpzgGlrOSCm/gQzPAOLtIoHqeWYvkKgxEiPBLZNXKOnqF9Jd3c0cwYC0Tlzm3nATcFhp3U
	/srZeyztagwEegXTIUbGjqZzg54Ulr4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BW/mBQ2X";
	spf=pass (imf16.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.210.65 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f65.google.com with SMTP id 46e09a7af769-7c7503c73b4so3127849a34.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 00:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764665720; x=1765270520; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OXSmGRnNXYiolaBmLEqVnw6axmZZPzNuLcO/h/AgF1U=;
        b=BW/mBQ2XM6NurHeOOU5TXVpdOFXB1D/1nPbR9oTYbX/LdJ8ETkAkJ6PPBtExnmCYgz
         06sGOuNhrf3doJuzp4CNw2f+wUqX7g9UtUnarnzZ3sfC157VJnJ05T7qip+tZLZ/qnCP
         V3L613auzRqSzYB1M8bVqtsvta7vfPOtIozs0k4u27w1bWE2HQPFBk0cy+OFrEsMblc9
         vdl+tbRyM3NKhNcRddl7SCedAaaw+pp2rbJLmrSRPBcAvtpYSdL1vtepUEIx1oNbC4Q/
         JDw45Tip6hw2FL2YWpOU+69pibAw4cm8eaN07nMSBaSrq3FMFNUH4Ucl10YMOrLrEE5R
         9bAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764665720; x=1765270520;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OXSmGRnNXYiolaBmLEqVnw6axmZZPzNuLcO/h/AgF1U=;
        b=cUln3DivTE6CTXrJ7/EsR1UlDbtyrvWDBQfxahZLoSDQ/0t0VVtDTNks55ueGe+/5w
         Z1UP7qBN0whXJrRk+VQDjQhsQnSQ0+2AIYKmKgksf+TLXEOyOn1RnPnKUzPNLP+nZGnx
         EIClQ6uLAbbxXPCA6j+wmAFkNKCIBq+/w2xMfpCUf2Xr5E2NDDUX50qvlAq1dGIslMfz
         HmSJ68dt1LgvAVFKHncXl1AnsoRmt8Dt1wyrEO6Lvo0W6y/LberrRPpqcHl9SdM6TG1e
         qRKH5xww0Qq+sfuC2o+m37cUcSTk1nqra5nFDlymXNrKgbs2CmLOtjfxnuLEeY8FcQA4
         KGhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvfywolK6pQNCQBFNLwdZoJPrCPvD1h7Kc9KfKDnBoKuGldCb7otUMcOK8qP0sDhd+FkSHhZdSeA==@kvack.org
X-Gm-Message-State: AOJu0YxZdEVZxYvo58q+XsdsG5GtZUyDEMqrh8kCO1d8Eh5M1THCqfIk
	OrmLxpcyUlC+4pBt+byHXaCCq2DFHT570ltUsXtLaDxtOHd9cCdUd19JUk8qeNV9XYijvWbcXVK
	AwjP30t19wtfJVDk520nbap09le27LTE=
X-Gm-Gg: ASbGncsgNtCnzJorVKRB330BH80XGImEtNSoI6knutWY9Veery6TCyOp1FLtmteKAhA
	yr1fObx7fWibcxacOs/OD9NxegyGNLIV54MYoYWj+Os124tgbc25+N1CQHQTRLENqPXKw+1FmaW
	lS4Ei+xGyGI8pR6VLRzYBfTHsyYou0rcRHtH/qTRSTeNvHCUJZ/L9l8RTNyISm9ee+AUoxCV1mw
	8KQuGL0i7OsD50mqDlIPkRQHgiUMGbrk5WFPSCzAzEbnhb1ehOOdr6qhScGXDhU3H9bkqYX7w==
X-Google-Smtp-Source: AGHT+IEHuE13vUuoeLGptLbSnrkm6EDrDAgrYaTLHwA6fWA/rKIIRvdg1Qg/eHqHwdn/4++BvLkhnQDBSmouhR/17pc=
X-Received: by 2002:a05:6830:2b21:b0:7c7:5f6e:f269 with SMTP id
 46e09a7af769-7c798f7b99cmr23550694a34.3.1764665720605; Tue, 02 Dec 2025
 00:55:20 -0800 (PST)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz> <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
In-Reply-To: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
From: Hao Li <haoli.tcs@gmail.com>
Date: Tue, 2 Dec 2025 16:55:08 +0800
X-Gm-Features: AWmQ_bmoIQztYjgUhsF_SQ3rxeSlmqGrcHNU5kFx-PhyV7JaekBmHH5actoGVAY
Message-ID: <CAAXMevrpusqiq7w8vYP_PScQ_+SEEUrMf7cFsMnv7M3B2cQnSA@mail.gmail.com>
Subject: Re: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AA81A18000F
X-Stat-Signature: qhrh1ujbat4gigdgnebetw7ro7xi4bmj
X-HE-Tag: 1764665721-201950
X-HE-Meta: U2FsdGVkX1/9cqOWCQqrpyoR51wYfj8vaaX8cy0kLEgL6BDhZB64KoIhd4rtuP0sv20poEdTHYO6v0URpuRyuUebnfv6rtOUYDtpbk7wBTbXYXmoNtlssT77K6xY4IgGRw6Wm1S5PIn/siiZe+SBp+7lGeuclbb1WNTVpFh1srm3v9+2dOuxzY5sOd7BUmxqCAHC3ue4ENt6BMZCCCUQqcYexTXTe02GCq2+GaTHAQXGwRyCjo0SIxqkBdS/UtItjLyBP/bRaqkInQHUNKci/L2IpgmsYABeYg357AkFoWsQ0BYRhmeWpW4KpLoTYSSZJYC4x+zdDQkd+hgccke+a7Sq3szYHV3AmAi8gcif9A+hp+iLhBEBjsnviStIe8/5IGXBu/J+kWrg9TVcGGItBj4Ce6ysPN5/GHADcZye9mgP4hPn+G97MvrwUH1BbrhaRk6gsZ7KG6oG0WhrwX2lxkhTwdO+/8I5Zc2Q0RihZ/MtXOqxpxQ4MQOIRvBrmp3Pi9JoIvbHogRw2fIib1Ti+xxdOCzfF1/hzlvXEoWgr5d7m0xutTXsc2baUhz/pq0Rg87tKKYXDAbv7/9PHnr6iEKKHka98apoIcVOqgKjrZnrGkeGTECFGSZ8hubvQvhQASJ/k5c0VEBlLHM3O3J+Lroaq4KFo8dGSW+nnOXp85JTIIzMO0yERy6Mr+mUwA6nBLIGi/zQt8fwXgLaJ3gHreG2Myde8isdEO7rTLEQTWrCEKdYbIwVSRZb046Mvx+EJjfvNgDR9kdFeZbXienVnZs4Fq+osDhc6VgTEfQN1yKus+WDPxDU6Ly6z5thUC6oleb05hDj+BKbfbwGPqXbAELQAM9DToRgxqTesi1syAGCaQVTEcVfB71dtQp41GYjvW/mk8Me3Mj55aTCFlIWmrZOVQ/wR+LtHD4dUA0gI7YCNrxiwI0Tcv4rr+bUPgvDr9Bu8EwIk4U4NxSJR7f
 quDKZOZ0
 eVY+m5srRnB9Kwlx9qs7WLWTRW4/9WbizCu+WnigSnhhODXQZvNeyRQiPXYk6h57JU+95hpa/qxo6hKr9TM9uAeq7FB4qVYZLMZVzO3KQBNsnudjaJIqKF+hcWcPdRe7m7E4X7/3YmkFrVrg2oFdryCAKM8C9qN6zHP4EMaEJzXbcAv+//qaeuxGuyaxwb+fgTQU5D98PUbwMkQJjBuKe+N6vyfsFJP7CCeEvfGR4vPFOuscw9l8PaTywIROCY2KB8r+J3M8aedyifwoifVpKQ+zWYErkQ6XS8G+1D+OCYWTeRkvnaiy/A50RCU2Mf7pWmZu0qkRs34Dptv08hdA+GG55LWju2VondZy2tENJOF7eHCjtczYYwrfG5jMAp255cwfIKncC0TR0iOQ48N0gGgvYu7iS3q9FurkNePOgSNkVJJbHpTxJRX2jBI7cVn6t84uJYBBYVaa5FrlXfz1xlQ690cCv3SqdBBPuzOgJ4kaAWjpj/ZltRdhj4mlALcPQ3QQZXo2UGIAOFfUj8XetmVKAjsAFgDyA2SlYE5whEnAJV7/qswNlhW/xy/64fOgPJn780TLnyRZHJP58qYeWjZZbwoBEf4tsloiW7XioFPpGyV+XK+QUpvRyjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry, my postponed is messed up. I will resend.

