Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A502C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E1E6B00B3; Mon, 14 Sep 2026 11:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F78D6B00B5; Mon, 14 Sep 2026 11:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1886B00B6; Mon, 14 Sep 2026 11:04:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 575046B00B3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:04:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A31B1140185
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:04:05 +0000 (UTC)
X-FDA: 85212688050.19.CAC5C7F
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf07.hostedemail.com (Postfix) with ESMTP id D5A3340003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:04:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R8YpPUig;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398243;
	b=XeS2IPn+P1gitGCsaNaDOkJD31IZlGl7p6bv4MmK3kKHedfhC6u+eiv2JfgZjyi04wTZAn
	fLRugJRgLl21u1POgaOjBtebbMEhhJ7cChmrXIiCe33ojPqxGov3bl04FpmLuLo77w952p
	F4Zk1iypDZnQvJlYiqNnq/8LMI6h0G8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R8YpPUig;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVNFzTfzSOo1njfHbCOBLAlgi9bYJJLyVSrWJc5ZZbI=;
	b=eO0vHEdLep66PiNDqMkLW4HRWTy3cUKlAJJtGO0r28xHGXdWllCHPsARHtY/0Bb1JA6D7F
	6xfUnJFTR9T5FEMKI2Y07mnrc68PsfpjD57+sanu6XZeZlj1dTnxTxB/SIwTu8d2NtxffT
	EOkTlDcH2SXl0AN203JSxQKu1HGTjLg=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb76c9deeso35099601cf.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789398243; x=1790003043; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IVNFzTfzSOo1njfHbCOBLAlgi9bYJJLyVSrWJc5ZZbI=;
        b=R8YpPUigMqC+Y6m6Owm6GatNvC28FPfUZ4vr8TkOOx5XmUNRSc4JAl24ZXD6KoZomF
         4HzAGzeekXiUA8/b/Y6sbZrAFuTDLY9t3Q4iEWtIzHfaOtYIfwtMV2sksmqZZPRClavk
         OYxWT6P4U8ht85Ch+S0NWepDm/arnppwMp3gYu1BbOa4yux+drAURVzV9V8tBUAkcAvp
         fNSpJ1mv6hujGf6XkNqjAzGy2OHlVPCUQCmRyhcZPbGOW62iodPSPGG7c0z83jSTKLcL
         BUNqVdT47myily0Bu1+I/K8DyhA/rGIhHeftYVPOlLbnrXut61nrxmwAkT1uQgDpDyXV
         EEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789398243; x=1790003043;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IVNFzTfzSOo1njfHbCOBLAlgi9bYJJLyVSrWJc5ZZbI=;
        b=BAZPxlMfAkudiyk/GHOWE7QtO7gDqjUvrMgoGaHc+5XHSo5ifSgx3wIFKA9wht/WXk
         HuPfjpMs+v1XzSROdVubGx3QN6XXqslq9Ycj6ae5aMPg77vTF0Ku659UuUVzo7qaR9f3
         upIZIVPGQhsDXLEI8ncQG2ku8yDCYCz/kkYM8RPcRJ7qLiRxjL3Y3zGHYjYnZ3nWHS3B
         gq0nuwb6WckUf0eEc9qSRLtSfwsDQkPNkuzlukpp+8RCJleFTGdl91SAxLuyX8Gh8ZJX
         mLqTD7KrVbMXR2iZa4UmnyC2b6WowJhkTBlQ+TrBNox7W70GuXh/16MP3H3qlzl5KlGx
         Hiyw==
X-Gm-Message-State: AFuF++nQN/bgF1Ci5NqMatGlH995SLuBYY/brxyG0c9alj/e1kTlhS4T
	3iMh7a9/9wsgAdE0I+uCm6lbHb58E2UvnT0eHEwl8iI9RTiMPGY9HJZDQNmEfOu19tI=
X-Gm-Gg: AYBFou0+AxxC+19CSUVaDkDNFqCoak52oGCzdu7FXcNiDoaGAqc3ZjxoK303m6iZIk4
	YJoEd8qbFGbmv7rn7xMybjBN1MkOzK9TqySHBvHJoCDu5VZJv2JjXza6K5OAGgNZ4IPkDzTh8Uq
	iNDKfnKmKlQ0GiCn1TzPe3TZo/lDM1PSf3DRm0jYVDD/rekCuLinf3y++UPzQBT97d3m2aPLUd3
	rnYncbMKTbCelejpapsgS6EMxDXaFTO3SiqKIaSI8eW7Ns40wkF+hNjBhcRYZ1gJP/kzjUX+K+A
	NEpMqoqRVZ/iuZHxUOhd2uUcgIPIITZkjp79JQ56s4lTgLKvcrzSfiZkdciyLhLPJ+A/ZF8NO9f
	+2eIUM5stnFVXkQWZ5/QNumdtUpQl7OhG1MrWJGbkGS+yn8puO2FHVUdE+d3tv0ZeegFyhmsS9E
	d5mU6WKN9elSleSIzupQJZ0hS7cuduTQw5/7pGvKI2mgkD7e1UEJcikqqnsHAxXZNXX6YmQRmOI
	p00vXSD12X83BpynH8HcCMRpTBqYBMA6Hz75k2aKL/q3cNjSNNtN/Bh8z2K4n05og==
X-Received: by 2002:ac8:570d:0:b0:530:db17:b1b1 with SMTP id d75a77b69052e-5310cf168e7mr41979091cf.8.1789398242896;
        Mon, 14 Sep 2026 08:04:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530ca4b9c54sm99561571cf.20.2026.09.14.08.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 08:04:02 -0700 (PDT)
Date: Mon, 14 Sep 2026 11:04:00 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
	hannes@cmpxchg.org, ziy@nvidia.com
Subject: Re: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist() out
 of build_zonelists()
Message-ID: <aqgMx64sKalkDaoz@gourry-fedora-PF4VCD3F>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-3-gourry@gourry.net>
 <7e247c67-ea51-4c2e-b02d-8e5ed31cc5e6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e247c67-ea51-4c2e-b02d-8e5ed31cc5e6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D5A3340003
X-Stat-Signature: c866eppbf513mjds5ndimhhqy7oruyk5
X-HE-Tag: 1789398243-348193
X-HE-Meta: U2FsdGVkX1/Aux9IjstMzTEDG6YnGZamnbAG5uFdxE9LO0oyYUZI7wGl/sQ2pDQO0/dfxR9LeV03FcKX1rRT3B1in1i4OhmmRmNrg2Iy0qzxnOf/LJ57CMIyV1DDEN5euhxbwyNjM0ldZotbAI2pxCwKB1Ptv7iLXq9kdzHHUAt2LewH+LGBFbYDKxAzaFYXpYedATxfIlQlgzyzjKfwTK0vFNXyRLVMDIHw3JPhFsFNIeRZr3/Wr9hzaWDJBpOXAERO3EHXhDvwSC98i1c64swS6tQ1bCxnRl1cyGsqR/ghm8mNCCG1nWr7P4vhD4HUTT2i2YxDDQYVqC2j2yg3IBg+lQBuCzvtLzZFY4w67ECNPf4kv0oNa76eOCMPNM+M6zLQT9ZbP5bkEiK6ckCGqqCB6+47jT9oSVc1ztZB0aMJdJzueN3dQYmSUDqiAn8vNuoNy8uttwR4PW/5yjhEKv1cl+++PNC3FXA9sIsbvo/R6cFcvtx+4rXz16wxGhFAI4CrpCb5fXaYbGtloV2vl2uP2nyf4wKc1FJ0iJprI3ePUnI2ZugzvR09plp0KdhyHLqS9ku3oYTcSyUciKpc5YAFEvv7mZolZ2nw/GBtBAp09FZ56mIun0SrpcGHYq7sprv+WoVhMerJA+9FYfwEfZ8xcbdqOq9RtRGk+P3GLNXWCHAAZpVZxiloQI7OcE3DXQFLV2FrdRgfpAwdfHEqu6JX6F84OJy3JaxWQYjvN7ZfxYmEfHV/xPpv2QNuPAzjwZ7CqFG69qB2Hwf/9OW+F/gV3r6vcDH0Col2v5XuW7sO//oFg5vORwkP9cWkCqP5Efhdp92r0AkYTgHMjlk4wjjk6LaRdxWmrBGrXrKgowPnIaigD76mdQQWfjR/+FrJK2nuq0NmMzp3TN5noIawNUDkyW2KFNon1iBzwcmiw3yhK2bWJX2WTJb/tosVLdOokrCK6o09FOFY/GGGtRn
 UfMImq/s
 mLAcr8GeNyy0H8ZHjP6z/lgbzkXakqKKccfqS2+GdrSVH5RfGKf/ZPE1KwEMGOohvjaXCVFpTZrmmzzc48q4Xge74A8DT5tbLF5Y+10c6nPp+LHB04cX520NFqQbWQA5TgVoqw42sOfXJITva1UbLwkSsgD1KIQa2DCHfyxv0yLvnvvht/NQGOJe7Oi/kS0GJazfB9xOlXfbbYHJNbqK6So6OW5INzOeiLQ0aKfdKg/vhhXGdeWKb29ahk2fQOTAnJ+TSsvSYh1c8T9nnAyGozk4OG+t5ofqBbO0CG5oM26JGMz3cf61Oc0d+nfNUUxn95beKPMI0ftnq780rhZL9j0KGHGqHWG0mZKLaxWczQ+qOJ6/raze1jlZ4q5VSIWrZS6e4JIK47v+nA5O4wscemhNVJzVkMa5FSZLLjI3pAvBXRm76xYV3B7ALPE37JPVlQ5moqfkLb0WYpDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 04:56:30PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/12/26 05:04, Gregory Price wrote:
> > Extract per-node fallback-list construction into build_node_zonelist().
> > Build each selected node directly into the destination zonelist so no
> > intermediate node_order array or node count is needed. Print the fallback
> > order as each node is added.
> > 
> > This lets us build new zonelists from candidate nodemasks instead of just
> > the default N_MEMORY node state list.
> > 
> > No functional change: build_zonelists() builds and prints the same FALLBACK
> > list over N_MEMORY with node_load updates as before.
> > 
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> 
> Nice, glad this way of refactor was feasible.
> 

Yup, came out much cleaner than i expected.

> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 

Thank you!

