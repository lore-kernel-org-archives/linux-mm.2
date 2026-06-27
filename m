Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F33BC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 00:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 565E06B0088; Fri, 26 Jun 2026 20:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C856B0092; Fri, 26 Jun 2026 20:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DBB6B0093; Fri, 26 Jun 2026 20:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17CA56B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:59:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A0A91C357D
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:59:35 +0000 (UTC)
X-FDA: 84923884710.11.130D070
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id A138D18000A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:59:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Mefc1dYg;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782521973;
	b=AoX4eTNS2vuz8GKZU8gHn2GsGszdZsq3AtSDRHfChAhkEMpPdwf3WZGVD0oKDMLKj07IiA
	zalV0Ss/UK4AvK9xuhMOipS5yXUgEPVlRMGSzrp2KkDMnAqN2v+iU0+KIO42aFKb8au1Dw
	7rEFau+j7pFLS8yfmoJNefcUfZaBXAQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782521973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6fI86SlfzCXqZetzJ98HYtjazk1qqu/5Wh9zakbqJk=;
	b=Pn9QugnKEVog0OaLZ6yQgN+XE8otvIXDzqRKVX5Nz7TJcHEqpcVva9qYeKFzIsCHVmx3m5
	mLvZuJH4Z6w0cD7a7AXq6OYfnZDTw4gIyJ3Hih8FpdukCJwwYw98sP0Rd3KEAAfk1nLRRB
	kmzh62vqI6mAcCNVXWOW35YYaPbTvgI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Mefc1dYg;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-519ff1c8b8bso16832761cf.3
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1782521973; x=1783126773; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6fI86SlfzCXqZetzJ98HYtjazk1qqu/5Wh9zakbqJk=;
        b=Mefc1dYgJ71Uf1tTnzmtbtuJfs4ymyqXFzkh+/cRt94wFb5SKICoHQo14DRmi/ixXW
         G31iPHPmGSeSgQXbGd+MY9lRz3AqtAJaZlrc4/oZBMlAQLXWs1t19NYMzvzkHuw+rysO
         654udV3N6Rdgbid/yjZKctW8FOLgmXtVCxPO6MVlm0i1Sxoz85PhBGamW0sfLqMhj/2H
         yyBY7HxHwkl7jEokKrITk7WbGYX7rrc1rMlk21/oZU4QHL2xRW9UEPRsS11xaR+iBa7u
         s9s6Cs0HY3gW5L+y2OYFgPHyGImlEMr86iKfml1f7RN+ITf6HNS6aFMl7wreCcyv240+
         7+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782521973; x=1783126773;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R6fI86SlfzCXqZetzJ98HYtjazk1qqu/5Wh9zakbqJk=;
        b=YBWdnhM5XgpAhZ0U47jW68JbNC3daAu/gML9x8iwvRMx/jLVjdAcIEupbvt7zyYaQZ
         lKnJK5PVeIJ7f0sK5GdKhgeYC8RqDITG/stFCxucr04Amu13UHnEKg2qZwSP/Y9KVxnG
         j2Poaf8DUr9ZqA8dfYgEJgZZg/UmT8JwrCeI6sHKbSNmALfWzIsVsMJTmnuz8v2pV1Wx
         xXWVjzdKp9dvQMuY8uDz6Z5+ryNdpqSlo+swsPTe71T5GIZeE4KQZM1qxQfUP70MEOlv
         gMhQ08LnYTx5UFQgvoT83b82ZrkNqbu+eGGBoKJ1vjSJLKLCcfLUtyV3F3WK0Dtb1s4y
         L9Dg==
X-Forwarded-Encrypted: i=1; AFNElJ97/Arakc5+aRWQlaV5FxRV/NR4hsZPBC9I9S9y0NizGAd0vF5pp0XF3mgSgUYfSdpgEpNFETOINg==@kvack.org
X-Gm-Message-State: AOJu0YzK0eVJgwAf1DRK7/ChjPCWcc32TYYmCJo99dyi1YcMsc8XwKKI
	3kP99NIYpZIuzfr2mlJO9BEVMa2tXQuuYz+DkJdufXl/XmQtkgP74wRyKzPro04dZgM=
X-Gm-Gg: AfdE7ckMF6Y27dHMRB1Wkhmn1/NVPxZwmh1nuE1AgZtxiWUrSRcC3GTBSTc0s5IxTop
	ANL+x21zSupBIgWE799H4Bd9JXASMKE/aAbpxpIzJyBun+4Sv8+1UBqG31i3aFemggJ9m0W2EOX
	Dn4TOpx/01V10P3iL5SK3Z2LL9p6aksZzOG8KIr3O33Uf+E+o0vGoflDYKKVmcwyD0MuJR/euKs
	apQ89J4Fpoti/sU5DcdCrk/sUW210dxVN8PqsL0Xs7rMs+mUYvAM9RMLrK/NYtCNDzGGORyPzjz
	EOVO/rzlNPopuoVziGyvhP+DI4yPH1cnQjAnEIdXRJ8J/82/Jclt04hoPy7zNFJJnCYIdqPJqST
	XNBDW5g9aDN63LwlH1h1b6033ZZ8DpSC544dnRNjiMsO7V4X4FzUAnnNtE+gEp7dVoBK89SSrkj
	FXrlpLAUcshHj67Ph6HwVrylA6G7QwMpBDcHBg+olkNIKb2NnV7A==
X-Received: by 2002:a05:622a:652:b0:51a:8c97:938a with SMTP id d75a77b69052e-51a8c97961dmr30547341cf.65.1782521972789;
        Fri, 26 Jun 2026 17:59:32 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a876c888bsm18434161cf.9.2026.06.26.17.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 17:59:31 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 2/3] kho: add KHOSER_COPY_PTR to allow phys copy of
 serialized ptr
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
 kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260623105201.3724592-3-tarunsahu@google.com>
References: <20260623105201.3724592-1-tarunsahu@google.com>
 <20260623105201.3724592-3-tarunsahu@google.com>
Date: Sat, 27 Jun 2026 00:59:25 +0000
Message-Id: <178252196519.136430.866206127737477576.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=418;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=rwTVAsBBkl6m9nXDZzsnVlHfZlLxgx8r+wYRTya4rFU=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqPyByUQB3ZtOZejeLpITOeBDenLDFWImk+jAt5
 d7Mnw5s74KJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCaj8gcgAKCRC7dyhM23N6
 3kMzEACL+IpfP2QOYHoFVmDQ53QyykaWU1CyFZYqJxKRJOZqX+h6ti5kZr/QOGsJtRpcAKird5V
 nh6fuSEvCGiYyRbF5/zO9yMPaS2XLyiYQ6Bx5p6HCdE8RYtULu6ZXrqvy+frSw0ReetrKXJ8dfb
 1lBTjI6fbJpCjZnlxkGAt2m4TCJNn7Fu1Ww3uWyYrDYKVivpIp7mYLHIirsP4RjqpB+gvZNoCW2
 GJgfDrBKZOgFC5tX/9N6NrEVOAa0ga938R30US8+5RzIeu7GRzgU2SoBeAe7CAj9oTiJccLA6Gv
 DSRaurlixLG2myHzw66H/6l+oBHfQNdoAoDjSMOePteal9PDcJunUlv738WvzAhi11hbzIVyT0V
 JkpzfGq8aCIAMOHJf5ltBNHmS2YBhBIHAsuUKEsr1q3pF0lNdkf1A1wsfBihZ5dshufhToECQvw
 yTyN3+4uqnT9C052gMo/uJZPTBu6BAm291roodzJqw4opXE4zcx0SPBsv7q10ovTYtonbUa1yST
 phuAdlHeoDZsc2Jwl+mmbMTvf6moMDck59E3jlvb0Uym+VNEEo/AZsIxO5k4bPRSQtA1gU+s8ri
 hrXSXwMlBZuKGqDRwOTygeb71UMdrmwG55Hy+gZp5MgfYUvyo/JH68xtWyQpkTYPejQ0vIAyotF
 /68hf0eXsNoWTXQ==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A138D18000A
X-Rspam-User: 
X-Stat-Signature: 5uxo6t7qyqcfuabjjg7otp5rp7jps874
X-HE-Tag: 1782521973-67284
X-HE-Meta: U2FsdGVkX18Aing8JaB48IXNON4MxBOfsryOetoSThR7QCu7lbFin+3qgq84Nhar/xmaQBkEb+fUyQGstmb4SpB9ars+An0IBqFaoBOh7at8Vy/7B24f/+dkNx2P2P2zLgWtYB9PKUK7rwkEj61tYQx4wpDifDBFTa7v8TaS5S5L0Dxvt+09AFUNpoOQf/TQ5PtS81fKsjateJDpzdjRLOLXnvwV60RxEdJCkL7XoFFb3HMVHRHP/VwO4GHnV3o0PwZI3KlNVhmpMojAK3xM22XXYZP1bIl5zvAxbmfKzrGkjwR7QiCp4CwrodnURiJPOzzH/HZyESV1y+WHR2pV39yPgsmVhd4HKBeZgelWrNKUNNY0UTG1pcuKFnhGH3ADMyjHxEAS+mSVohkUSlZY+iKFPAP5GaIGzGysD9SJbh9h1QWmtT2l/GgZhwBvjtWlO7/KLuR4d6mN+Tj92K9p2Yr//9+74XxDPttL+7UjCtx7+M8XHBglcXusqF/eyMW2nMHLZOgER90sG+cKlODGDXoHf+ffufEB1rUNNr/p4aHtvvrEaPx88fws0b96J8nqqmuoI6L1rGrUNwYJXzuDqofv6MEe6M61r3CypIzmXMFBF3/dkZNI0GW9TcgoEBGSHUGy6r4xzC3uJoVPsgL6FsLq+hrN2OMcNvOjEusPMpfxX2YxeL2MkNKVxXTZ5mggRZYTd3pTIUf1GENAaPou7hu8mZigCpw5oyA0NYdQfF5hUXlXlhlP8gEVqalMJX4TRrQm+48e+dGwEtJnGyzeyKzTwu3gZUuLJcDjkQEMm8bOp15NWSOcotk0R5NIHiajSPG1tNL67X2E97Yw9CMXPpg5+V2ZssW6qFdOIAgCmYMqQM9Dc1ZLlVkhgUZNfSQzoLSlAadeAnj7+Gnf9i0qZFdR1gTdQMxTy5TBi1OYnhVvHLJsQY09Rvi0F2IcaZfSGeLbzQ+ojT4kXegHekV
 QqFXVbno
 cQUonKrC6NReUfkzhIdgCmu7QHcVhwVGNliylDYrh4KBD8wfN3dEdZ8GOnMTVEm5HvcGQ6wAc6dusmhrRR+kByvngqVh585WD2qgV6/1N/dah9lGdXeH9QwNb5FbZBJVAlOqT0mzHuIE22RF3bA6Wpt84x6vvpa5LjbRr6p3P5NC6f+G1QPaxLbRtIt4Qcv6YdkypzMRPmCG8mE1IynWq3S9adrzKesalnHwYWhHLPfKjn+pzFItTr4Ju5V8OOBPHDWsikTCWv8Md4aSF5oc9K60cAKO4wD28SIPOUuVRYNWXL552tIUQf3Hbg05UsOyri/C4AVePEKoZchn8CIhVmH94Tj9R7L5WEs2syts6D/dulifULamU6NyNu8Vz8OLwF8rvAZ5pfXkYyz3J2VDV3Ett9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 10:52:00 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
> Adding KHOSER_COPY_PTR to copy one serializeable pointer to
> another. It basically allows copy of phys val of the
> serializeable pointer.
> 
> It ignores the typecheck if any of the argument is of void *
> 
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

