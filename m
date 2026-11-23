Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E353E606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WkBxiV8o
Received: by kanga.kvack.org (Postfix)
	id 076426B05B1; Mon, 23 Nov 2026 05:38:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D556B05B2; Mon, 23 Nov 2026 05:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E81F86B05B3; Mon, 23 Nov 2026 05:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC4F86B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:38:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CE96160831
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:38:43 +0000 (UTC)
X-FDA: 85466035326.06.AECF3F4
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 88A0580002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:38:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=WkBxiV8o;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795430321;
	b=mGYYvDJWtx8cLRjuSAJTSQesAeO5Ph+PG6hsHjDyGojgdiD6K83ruglmZU2t6YBxGaNpoS
	dzs6gWgfGy9Jq3KLAB1tzIAl4nhY0DGurgsKGLC704urx7+nG0olFGiOX71p+5Ola2MTpJ
	ARr5sFE+kHs+ghRUKasXeH06wocAtJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795430321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6szjBBJILKuRD7pQG11cHKqbE2vKQs45Jzb1CI0O1H0=;
	b=iTKaciO9jnw6RJU08PP3hUp7cvelTZQnttiCD+wuV+PVs6xd3rqEM0Jeq2rhkKj9puqobf
	F5Xxm15It/MPmud2hd17MeXThlBrDnw2zbBrgiOpiOPGqi8MJGzvjx5Kgc6RWD+hj9iRR4
	Qukp6SYnQt3j+m5xEPgMVzcav/ml3bo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=WkBxiV8o;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-679a2b5fe87so2877830d50.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795430321; x=1796035121; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6szjBBJILKuRD7pQG11cHKqbE2vKQs45Jzb1CI0O1H0=;
        b=WkBxiV8oV07EFbfKu4H7E5GXPwrr2ysxxdW2EUKj2YfpY0LSYzQy3zxIxk51XbL0Pj
         5iPJCjU7UwajGkz37S64F9Omqhs8xDiLydexhC/VVS0lfBVWS9dJMxqutOqjA6/6mUt3
         D0lyclo83/Qn+eZcH8U8Qk4QzYgOTgyC+UmPbenjMZOYaXz4ZXPZM0qrW1eUZgzcFYaC
         fOys8oa7stS4kFblaHy/By+JqktirJcd2pJwgOx3JAO0EdcNOqEH18Sv756jNK0cvHxV
         xw+zP4yGJyNadF6SLbdWxa2TG1Md1Wlf8H38yxUEV9v0Oh19QLMt/9po0dctsHZEy7Wt
         3wqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795430321; x=1796035121;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6szjBBJILKuRD7pQG11cHKqbE2vKQs45Jzb1CI0O1H0=;
        b=owU4uFsgQk/HCptfvI7N8+Trc9XVIUvNNbEZJHRPD+on6ploCFlo4XNJ3Ispmc1+/G
         v70TuZSjqVlZ8bnB3FTeuhI6X0qGU19a/BiwPtP4S+3IdZNLuazsex2taTUEvye+91n6
         xGxLwYV20bDKlpGod1+YbdMzrit9RCpGia3MYKSv0f0K6sKW6r7tryMuZkVNFQ35ly+Y
         TTW03xRJCAMziTJ2xOmYH5kUiVI3YNH5osphn0F1daWiAEemSsXFgqSDsJl6vp4pRGz2
         TOzCMq760iR5o5Bg65jw2mYd6pQGHDXiIz16vSVSJdsQNKFI3e2p4iE0r7DnMBrd+w2/
         VJew==
X-Forwarded-Encrypted: i=1; AL+hErFV8oJc5qVnwG8LnfrC9VJWkIKjvPjcr4WIqak92fctxOLI/BDrr7RdYSDaoIM9C/QV0xf5W9J2Gw==@kvack.org
X-Gm-Message-State: APuU4Z9CpgcZ4A5kZbpWc4Wovs8A48TpX+MVGbJAWyDOP66ESBZfK5p2
	WNDcIXEce0HEllWz4dpg2T9WRe6d6IMXCZdWWed+Okm+9Dh83AqwNPPPAsVDeM+d9Q==
X-Gm-Gg: AZFdTZeq8wIdBOLkVdT9rXhsUSu/BOhmXPoV/kPLxcHnFLh83rOYVs6AAAkAvsbH8Si
	wKYGIUTKu/tFHO2aQy36+wr87UVsLU1n5tk/kBKD9rblbrK+Vonan74t5eoUOdNX+oIuwD0WO76
	OI3tF4jq/5SaG20thSdoFWHe2No/dG+SAo0MhOsweqyD/cSH7L1WNrfPS3z8LBe30dobr9aUIIa
	4JtFbZzMzO1HfNyNaqCn5ROryZVg6nJIGnCK3Q6QjwYncccPOjpwJKs9j4gOfkj47XLK9u5PqwA
	KJTcZDh+a0vESYdHIQuHWAgIkTALfEa8YzRciCCKybzvrr8P6XiDLt9AC2GcLi4wlTpKDzmE9BO
	mG3QqT0cOmpOCIMo8vgN1MNvtmvFh2Aj7sHpvz9DYZgRNNiyvIp3g91K8DlPbZ0vI7MhTw/NDf+
	Im2URNwqVB6GJjE2DBCCe8QqxVAr37+lw7x3P/H4vtIwYIoXzkQyDsA0xcMAvlqIAiL5IrhKuLp
	erEsp7wOGqckS5nh7ZP5kl1LasRrK0DlYpTsx0fx+r6xLPQBWEJv//R+oDLBEg0q+fUbUX575MB
	XqRNX7I/O2ouzGdja4RKeMVlxSCw8mv8e4wTm4SxzmDqY8ODdZ5kXY02LjRzHHLAtGh8l+gcnQL
	AmVcavisFDxrR76XC5ioDF5hE
X-Received: by 2002:a05:690e:12cc:b0:679:a943:7da7 with SMTP id 956f58d0204a3-67df447de99mr4064285d50.81.1795430320159;
        Mon, 23 Nov 2026 02:38:40 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b5201ba5absm43963477b3.4.2026.11.23.02.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 02:38:39 -0800 (PST)
Date: Mon, 23 Nov 2026 02:38:27 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Ding Feng <dingf3ng@gmail.com>
cc: David Hildenbrand <david@kernel.org>, Brian Foster <bfoster@redhat.com>, 
    Hugh Dickins <hughd@google.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] tmpfs: zero post-eof ranges on file extension
In-Reply-To: <20261121152706.34523-1-dingf3ng@gmail.com>
Message-ID: <c0c81eee-31a5-73e3-f113-deb1cd8a0b61@google.com>
References: <7cc5ca1f-fbeb-422f-bc05-55b3f6b6db20@kernel.org> <20261121152706.34523-1-dingf3ng@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 88A0580002
X-Rspam-User:
X-Stat-Signature: eunhprboigiqie4rdcxmxap4kxsajprx
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795430321-76172
X-HE-Meta: U2FsdGVkX1/I/zX1Zc/7jHjfaS46Hr5eknan6JvKtRnW4DSPLkKkRaSUI0jZ2mNebENHXjJ2Tf4B5O6hsDhbg3IlW0F/kRtVC0BqgTMPc7H7pAYNNhb1HQhY4M48me079vbOXd9VbST4V+pK66ogk5BTOajAZ6M3/vVKgc/nEH7A8jd+9YsgbnTmuWQfa0abyuSF0OCzoFbcUoX1jO6IV4wgFXi7SLJdsWZyyTmBxJ68EuPATNB0tEqt9JJikApb3PTeZYPTOjPDksSSmkFWNJ2Zs/WmMPuE0JHfNHfVW4Kp114NrEFSKAt4qdMu7d28QFHA+leg7VH/w4sot1LUZTM/c1V1kJxZ9MfdSdRKD9OVyYWdDU+msiHHqFL1QaExLAUkSvMelMkx3Z2zUS8RLYGs25cNnaxdUJRdnVqhTlu5INEzmlykCBnNVoPbK99faLde3bisVP3//V8b7s1VVPhtCUEdGlq2UGpJ0VZYiXImjcQaQ4jdI0DcR7IVV83tMBLx5UkGovVU6ZKMDAHGshr7BfLws3unImGXVbJ0O8uRUvcn8R2udjpe25Q29zi+fNjOyRz+47Tz1mIKbV8f54UAOuIs/B1dO+usa8pUdVm5cplW5ljfl9WlwV6AUL/c6naqkSCTV8XhFUINsEXO27sPDZRWTaW0hLx5N/x3owP9V6NzM7sHtR4BOMrIa00X+au5eyreMbCb/gD3n97g1sBNkmmN/KAlHCzdIx8J6UlSXA1ucd0a+Kh7VmFnQ3lnscBYV3IWYdDs/JKfIwil/n1Lo3lLvXIjqUcmFbbNzHKf4+dR9HVr/phn1H5Lb5bjMbomGRIFg7G/l7tS4BBs3QulByj4mEtjY11HxMD1hKPP096VN8jMEaR0Szc53fKMiZ1TkaL0TinXqllKJb9INKbE+MoiI8no4tcVFOqhEF38SVE2zxLaCQJu42dv01qugE2nkhaclW6fcGUobto
 GzM+1tuZ
 f5IMHCCCJFbOvQDCzEhO88zjlW4/hxfP9YTkB3qnR/5PXHL0MADLz96u+MH18I4D3iGt5ONjKP0hTGVGxOTbVxD4cSVVPcEDJ0ZE0LJaNqrhK2JYp2zLcsACI1M509TZh4tcLXI9IUMbvP9d7VvOcvV3zfI5hUBMY+1HFzStyJPPskUfUZ2yu8nH6Eo2ioRWkkRzhoyGplHwqw9m3nBGG0guUls+kaQWGB/O2N7MjtiryKPzXMniO52C9UrULntikSMhf05EHPvjOyMatB80kM0if3BLfPFBHGNvdA73b80ycNd4I72DJWyGZ3OtUzP+2zBB9o5m5Frcj1/hgs6cYDY3uG7WcoXi89WCmwPt4nu0aMHSlIGBgTWzyeDPHqTiRng68rCMaxaH+jMkWxN2uzoxfpbGfF3I9m8gMH/zOwwmqIo5eqnm9DjlP1/as4DmJiaCjlZXyg8KHRs884eIV5YOyiPgXh6bGVGsbn2FmdI2S1Tf5M7v31mVrgjEma22rkNHc4ocu2c4IOuuXC9YSYlYIRalEFP95maxTfu3R6UEimlqtclrip4R6fuGwBRSwO4/+18JgzzRDdw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026, Ding Feng wrote:

> Hi David,
> 
> Understood, thanks.
> 
> Brian, do you plan to revive this? If not, I can rebase it onto
> current mainline and resend it as v4 with your authorship kept. Is
> there anything from the v3 review that still needs to be addressed?
> 
> Thanks,
> Ding Feng

I never did report back on Brian's v3 - sorry, two days became a year;
but it still sits in my home directory, and I do recall that I was not
happy with it, but hadn't worked out how to frame a response.

I haven't searched out yet for whether I made notes (quite possibly
not), but the two things that stick in my mind are: shmem_zero_eof()
seemed over-the-top, just more code than was justified for dealing
with such a minor matter (I know I had a better idea, but I'll need
some quiet to resurface that, and this is not a quiet time); and IIRC
it was applying a new overhead, not just to one folio, but potentially
to a large range, IIRC causing fallocate to zero all new folios
immediately, instead of leaving them !uptodate (in some ways a good
thing, but significant new overhead for fallocate itself, and
probably not intended).

So if reviving Brian's v3, please don't just rebase it,
please reconsider it carefully.

Thanks,
Hugh

