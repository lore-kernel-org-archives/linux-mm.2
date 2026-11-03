Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672FF606D801
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q7Ng5SHj
Received: by kanga.kvack.org (Postfix)
	id 789C56B00EF; Tue,  3 Nov 2026 14:14:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A8E6B05B2; Tue,  3 Nov 2026 14:14:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FFB6B05B3; Tue,  3 Nov 2026 14:14:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 456966B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:14:43 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D37D31A051F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:14:42 +0000 (UTC)
X-FDA: 85394759604.24.AC45207
Received: from mail-oi2-f8.google.com (mail-oi2-f8.google.com [74.125.231.200])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2D1312000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:14:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q7Ng5SHj;
	spf=pass (imf31.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.231.200 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793733281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zc8kDAvAGcUtSSTv1tiJtX+vTgkLMgafaiJRnJ1QVh4=;
	b=olNy1bqJdJpvRRVXybeXcjYLseRRIFJm/+ToiWFZELCp/pnj7Z1PS2ifUw1WjUzUKVPKaf
	3+TITTB+uiiVCWmcNYc3Jb4nclbAiJt3MgBLouhqL3lhNnLLHBdRa35Uj6S+cAFv808K6L
	YBzABjZ2G6pRebPo3eUF7i6nKLqbjK8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793733281;
	b=Sv5C33KMUqgr1BpNLEEEGC4pMJ1yR87fGaNLsYn9B8rhcGEy/NdLvX+8P67+isl+/3UInV
	qOXQ3LsP+UGJauH1UwHD8TuiZJJimO6VsSeHa7gjxrH8PAfxwF8ncyADa+0FvAxLUsCHmr
	xdQy6i3v9+hrq+3f9j02dMZtMGXttTY=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q7Ng5SHj;
	spf=pass (imf31.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.231.200 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi2-f8.google.com with SMTP id 5614622812f47-539edfadfa9so2040669b6e.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 11:14:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793733280; cv=none;
        d=google.com; s=arc-20260327;
        b=hFrlwDgtAJz9acpcIK6eFQSknv6fEKLHV6BWAs49DzDt9wLW+BdUB6N23yncCYZVFe
         /uFKWgBfz0WlIWz1qwT/LrkY7x6D9d//ckJyYMmcbnHmvKsIByXGN0DDVEAjs/x+gMEN
         OcTHcXqSh1Hm3ltSixfLQnMeLfAWRHVoXOUjEKG/4Py9FAYiwwbpBVYmJC2f31qbALQh
         GViCGmIFG8dUPhp3ptpF7+kT7aTNqcbhmkj3hUUeRSYueJO177jZ3Bn3UkRfbWi85cXm
         obf9rul7oJU9sZCMytMa5nUWkJjXltVNchbhB7kf1mR0C4UQGWIM+/fIGDcf1MO2+py/
         B2FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Zc8kDAvAGcUtSSTv1tiJtX+vTgkLMgafaiJRnJ1QVh4=;
        fh=KlMfmM17sPdeNr1njk8wH/tLk1FMdQ84hBiCvn0m5wY=;
        b=lWLKz++J4Y1daTJRvwsifXoWW4I5/n5U1g0UgaWQDKj0m+7nFT3FWRbCEqxgkIXvND
         fzRonREhcDhsXvKiVRqoEdzQL4N3aw9EoGiLv1dL7jorGUEYg0K11/uPRpBjHXlGsBxy
         FThTNq/I4Y8BFKJZARGnu2BVRPa6OOgPCeWWhjNoSy/O3DFcydLoln/O7oNHxuJLUec5
         Tteep1+t2m6yhlJaoqRBmw6FYjg13sTD0sUbGtwZ2oIkkrZSipVBFl/4GQTbfKNM4Q1e
         GvV6lhwHTcP4ToJBpc1u3PogGk95xc+38uYHFKhZT83yTHWIHnNXtkEFrbi4GeUAr5DA
         fkcA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793733280; x=1794338080; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zc8kDAvAGcUtSSTv1tiJtX+vTgkLMgafaiJRnJ1QVh4=;
        b=Q7Ng5SHjmWKo9Km5V7Ogq/T22i9YD1Tcc9IKJv0/1q/6vxjPrgUvLlFlBSv/xR5u+o
         co0AaqrGUgpzBUxD2+8ceV4f80iekKXcYBk8Gay0qxe1vs46IscnjSRdEsc5M1mchql1
         mX4Ged+ZhmNNKWAAQI1d7BXeY1zx2+SlhDyQwpfM45k+S/0B6SW5eMsswXz6ZNR78u2P
         evl96M+5wkYG/ickJZzcZdsyqHr5V7egl4ai/LQR5bjzF874oaN57hyhr9Axr5I5tfcA
         nAHt6Yq9Q/Q6AkLdhObAWBnWyhCyIP1UJk9hy8Wiz5n27RTV6Yfj5rM72czA10BFKJwi
         cPCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793733280; x=1794338080;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Zc8kDAvAGcUtSSTv1tiJtX+vTgkLMgafaiJRnJ1QVh4=;
        b=FWyS2H6//KVmSfNhLPAlYrgc84GJmNNgoVv7X0usgvBBH/BPJNDqhp2WaBWYDk/rZq
         oVMCLzu/c2XsTM/kJVkP2IRALpiT4cmg49XWs/xRg/X+tHLUZh4BdIGX6R+EK4kiChGk
         yWgKGqXpEpq5b/Y8OFb+pnX6jCNctUkM8sl/o7msSq3wyMi9UjV+/pLX+alg07obxJmJ
         LX7BT73y+P2tlveonUaPdaZk2T5j3O9QK3ZrxiHS+mDYtGLz0AJ3X+BKu8f41rmDEex9
         VQx0SidFWgETwgtHMObO7+qXytDlKculpbk5pQP6MDkhrf5SUv7CuTGc93qO+wRU/mtq
         +dpQ==
X-Forwarded-Encrypted: i=1; AKwUvBwOnEFW7zDqqZr0ah0wOlQgdpySpXhxxPqFCLeVofTRZUDqfrs6AZzDpd7unP6T9enYjxD7daYFXA==@kvack.org
X-Gm-Message-State: APuU4Z8qehWcUSM3cCWqqO0Vqmgt6sycA7acmfxFlsVGdQjanMkbu44m
	dUNnByEMRQJWrjS5pRAgVgXISnQhzg7K1DiNOucKjHzmDDy5Pw1NpIJhjj1Wp6fOvy/dNek7vN2
	huz4z9gQ4jFeMnyHFXK3j7E8tyEuws+c=
X-Gm-Gg: AYBFou3BkomAY9XljtndYtIobaLQCNzm3VpUdcGhNb977Ztr/qN4Bc0opuU3A5NHwa0
	EvvuLj49IbAX1Xdz9dDvHBHmE8ulZRv9s3OeiNbarY9KskXqtl+IPo3PSgHqFj/hxvSRffbmWNo
	in11ANN3HJA4g/Qi47jBnkCVYS3z5WcnMWBdEWU6ISdBMRmefeWkc9L72M4mN7IzkREakPcOaXb
	CdzLvOsnuZCTO8Y/Hg1MBlq0bWuqeRp6c8G18jX5nxOxE5syATSzLxFL4xHMYjPC+Yns8S4GLLg
	HJSy8aGkTJeDbr+w6UfX2Y5gxKZgMMQGvD3T6sD2aa0fFY1s/1OMCkd2NmwR2q8lmV2tF8xVFhP
	33OXtE2akum57Ww7tk0Ca1zeVM+OewetpuDN/bJPNHvlZyVyOcQsRGiMZeEk7v864epGr
X-Received: by 2002:a05:6808:3203:b0:55c:925:9d5c with SMTP id
 5614622812f47-5640df0b09amr9395153b6e.55.1793733279946; Tue, 03 Nov 2026
 11:14:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025164619.89992-1-dennylin0707@gmail.com>
 <at9xXRhD2xZhszEj@thinkstation> <xmp7ni65vbinfj4j2baisrhp6xzro3asbepuq7xp3mvx6maptn@r4dnoj63uw4t>
 <at-XtWBQg3jv3H8Z@thinkstation> <CAGEkeHfq1xZf_jMw9a9cz3iunj6O3UZ4-=iW-65aN2Ss0oT3Uw@mail.gmail.com>
 <rfvf7awrww55bg3hwq4edbz2ioorodlrb3wcmf45wcrof22cda@yduswvswhz2c>
In-Reply-To: <rfvf7awrww55bg3hwq4edbz2ioorodlrb3wcmf45wcrof22cda@yduswvswhz2c>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Tue, 3 Nov 2026 11:14:29 -0800
X-Gm-Features: AclHuK_K2i58ZgKI0ZncbiD-FXwtR_64S7t8qdGgihK-Yj_K5O78XEMeQeLdpHo
Message-ID: <CAGEkeHdALf_Pb8m+qUE5ZSqTWNn69rXyy33Sz1-PKJSmGxvYCQ@mail.gmail.com>
Subject: Re: [PATCH] shmem: do not extend i_size when no data was copied
To: Jan Kara <jack@suse.cz>
Cc: Kiryl Shutsemau <kas@kernel.org>, willy@infradead.org, hughd@google.com, 
	baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: nxd4bi7zq3riwqxyijx766jhjdxm9me3
X-Rspamd-Queue-Id: 2D1312000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793733282-566146
X-HE-Meta: U2FsdGVkX18HpgDx/OEcNOAzoWutq+tSdlptgFMDCqvSaGNOjmxZs8f6+N/2kL6Pk88mvqUFCnUaysitB7MjWwM2KFDW79bB+aT2F+u03GbV1gVnACvPmeMQcgTOcHQMeR+nuYl/PssB6uko1Z+DyjgIgQRvrQ0b4DEUTu8UA6Sl3F6ulQ0YCviqaVnaJIWUfiBpJbZNT3d+fuYopHJaWIW4ACZMyUXKshpN1BBeUuryCIK3yfPgzCjJFF0LI29+x1ePP9iPRU54wEosV20LsYqioLrIempIj9TVU3dTAvUiVsSZGerGBMMkaSMzxfKqGXalZ2PJYmV3eKJPP0j5NhXGfEpvIH1jyLE8I4+bwBn1bluUensUBnUprpISBXWO3q3MPjgYEOJl2NnzB4oErJ7QBYtMj7YvsQ9AAc/l+l7k/IyDeUMiW1X9+NuJijg4bfd1tUdZj1CykWdu5i1L5Kf8c9h5TWU/D0aPdpcrvkUzzh1ble6Gkf4UJnAUhZnBtr/+HS3YYeTXC0OC+MXum3XL5etR7nb5NqG1lMpW5Wtef+cbO+j9n/TEY2oiihEokJqo/kvIbh1L+RGYtwKxMjAz/xYA1XCOwj/wJamvLBAPRHnzpi9ArDbwxfX1Pq4Vb+VNzBXTSixbyFNOeEdxYhsUejmmXVA01P0Sf0Ew2nQ3FZSxCd1LrJQB07mWj9qWKvvNQhN66PlrUQIU8PEdm9SjhF2KH66BzbEEMrx5TJEzjypN6/4RX38lE96C/xE8jmoVS6b8lMFc4g0sVfZDqppYeFoMO5ybTSd4+NnCiIp4mfOWzDnnciop3T1nQPWYSI2uuMPGm0T0jCn3D+0y9V4F9u9rZ1Nbyn03rjqqEMvQYbFlvGsudDZT1ZLQbiCs4T9R4WZuOMqTKAHhsdY6ussrWxlES8+QKJVcQBbco+NIigkQc7U+yD5jfiXzTkIWFY/Bo1y/qjWmLqeTMpk
 eDDVBLRG
 mpiNCOnBqJpwLVPYkj3Yqdt2z+/tGwGiCHmd8UzPn0W0e3tr+k0dRkj8D32Rsfv9D+P/Sd/aFuzkrQz68oIcFBFtTvVN+6W/PItfxXvep7uSUbENj1OcFNt5SQ0DFVkA15vVNsXADRPpfFls7hsrsd6H6hdIhk5udnyKViPkhHU6XO+wEPysEsZxSd6TkWtqsGpxwYsT1l6HGLlN4jwmv3bgSjik5EfMlH/hJyjzqnWnuH+d9YaTePUaqNeJpbDcnuBIzTS89MrdwJwYJJANxBONbb8JND2uEQoNXUZVNa9WZbnNBvmK+VSbLvQnWVGnqQuSeq11twrGbif8G2QuI1YDkp+j+y+WegEgbfpEEDIPb2bnLNeSU9UPo6iE8J5ih7tpxPBUA+EVj0W1H+5ompBeWz0xINPxYIpsTAhr5y4zy0wtvAmlwR1lXtubf2hR9fLeq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> The trouble is that practically any filesystem is going to have these
> issues with 0-length writes starting beyond i_size. So if we can fix it in
> generic code, it would be certainly easier in the grand scheme of things.

Understood. I'll try Kiryl's approach in generic_perform_write() and test
it across the affected filesystems before sending a patch.

Thanks,
Hungyu

