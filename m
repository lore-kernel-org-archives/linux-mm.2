Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03150C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF6D6B0093; Thu, 24 Sep 2026 03:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B05C6B009D; Thu, 24 Sep 2026 03:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2056B009E; Thu, 24 Sep 2026 03:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D067E6B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:57:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4ECA940274
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:57:41 +0000 (UTC)
X-FDA: 85247901522.10.07626AB
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf02.hostedemail.com (Postfix) with ESMTP id 85F4580007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:57:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HJkKE8j1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hxnh7K5pul4WrdHHRSoLszYKzHojdYKXEO6rx1LCqCE=;
	b=pJjUl6O/YrFlsUn09yygbq/lZlg3VJDMk7wL6hz1RsVUroBWUgUqLEStY5uA/JTIi5z8jZ
	mnxw+HM/1pBV+T26cJhwbWWNdzVWNg8pbhuFLqWNuOEWDQ4XXD1EAoUSlQgRhKIOtQi/ug
	ldonqNFnFrKFI8Z3MMSzGqFlEpuykBY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HJkKE8j1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236659;
	b=5PwZggMchGmYn4s2ESnjiAgq35I0wIuLI4rYxyBXO0dauBf3GkbC617oQUtDNomYCxPNW5
	E//VSMqc3bklDHHoAlchgXSvz8ShyMMhX86jucsQO/zD/BmmksJdiLBErmswKVrRiBKFrJ
	gWNs3uRdPY/JsnA3hAyG1+77bAhGwPo=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39dbdfaef3cso976449a91.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790236658; x=1790841458; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hxnh7K5pul4WrdHHRSoLszYKzHojdYKXEO6rx1LCqCE=;
        b=HJkKE8j17dHzNfAwddClLMRs29Hf/AbY4v3Wl3pOBQxOKywmW8xqK3sehiSzdM2VzX
         x/z8unbmF8iv8AYXQ6kVu6OcnjYSBGLa4OV6Co79ANCfAgMkIFrZrKfBU++CpBtCXCpO
         m9uFV/k90hMcrkL3c28JimBZzlT0XEJXLravjzHAm5+bNrpLtsY2dCz+zbNNCCVLr05m
         Y54td52dk6dXKSRDUdrV8tZxNrZ6F/4gSUjES2Mn22f+Kxv6RVHJlhBvJQ1AB0tnMgsx
         CCimZvx/t2nKuxhLe51dUreJy4agVztSUcXYLnv8cIxw5IwE3hwGGfuWlayKK53YDcdY
         jOXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790236658; x=1790841458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hxnh7K5pul4WrdHHRSoLszYKzHojdYKXEO6rx1LCqCE=;
        b=CxplCmDbUzWsnnHpzH+6r+WZZuEmqqJabYXr4PN7idyGd4q1ZEH0D5xq19PH9ZOqE4
         TXmYmFLiaZ9lIvYwoDSJ0MO2DQghXZ7o9jPBo2A3bfqLBuQWOqM/L6AF2lVK1jKKQdxF
         N/iJlycFCwe0CL09Q8O6NQML6vXtSSuwSbn+CUzV62tI6G/UZE8vfCW8VTetJKH0MREi
         T4Lfcncig1Uumj3riEEaWNjhTyP643jO4qHFp9WogLei6h7CzLo3R0czmQvkdrpRMQQa
         kianGzqG1O2awah0/YCDe5Bx+6rkXywPTZ4OzyU2wVe9c4rPmIywdMzaqEsnL8Yj6pfK
         Mz7w==
X-Forwarded-Encrypted: i=1; AKwUvBwtrPkVJqsk+Rkw2N7E2q/R72Olv/ndKyYhr9lpYm/8M3SGOeDybsU++LMy4sXrWm9pmESq4dwD/Q==@kvack.org
X-Gm-Message-State: AFuF++kudbuqY5V/ntr2rzM4X3MOG9BiCklltc2ubU458XphaoAZfF7S
	xsWkRUFIgN0jvD1+ftQYp8C8mu0Txfvo4Qx9//qHS9GKohqf6ngeJI/f
X-Gm-Gg: AYBFou3iHfDIXPSi4k01m/SuyGA0aoAUHEFvXE28/6+ylLnPHHQL/od4ADshSnpLB6R
	J/7PTdJLKQqsQSS3iI53zdnrkqhboxliYoDEuSlNhvfTakou7EgI2+JSFHc15t78RtXCGclIHYc
	TKaYyAt3JCVQw3F8AlMleh/rphZ/TPJSpK/4lOJkKHzxOcC5i8KmUuTX1jwJJsBYocA10gMPm2D
	cn0NvyUMQAqOnp84H15g+Axy5nMt6sCV/xbtjjR0vPHYBBQuTgt77CaMD+DbNmDaMCa5DuWnaTp
	0PF5bOpqOgBJQ7u8Vul+Fk9CybGM3PzabJRPjDv7u+i59ybinJBnfbYV0eYBUAMQ36JaIpfpgJQ
	SA5hqRgEUU2Z8kJ9hFkwjaj0IEc2oWxC+bMq0U5/mCFagEq8BjmPA7KzSeQHL2YXp0pAZgAOskF
	vc2T084hqNt/a5BxNbd2PuFf7xi00oQtaph5DQG0Ki7O/Qhwikbq/F/f4qRQXLSRIgta7lGeWQ
X-Received: by 2002:a17:90a:2ce6:b0:3a0:a055:1741 with SMTP id 98e67ed59e1d1-3a0a0552127mr323462a91.27.1790236658340;
        Thu, 24 Sep 2026 00:57:38 -0700 (PDT)
Received: from celestia ([2402:1980:867:387a:70b:38f1:a1dd:9303])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0972eec92sm3573872a91.7.2026.09.24.00.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:57:37 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RESEND PATCH] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Thu, 24 Sep 2026 15:57:42 +0800
Message-ID: <20260924075754.6839-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919190953.86705-1-aethernet65535@gmail.com>
References: <20260919190953.86705-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 85F4580007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tk1yr431dro387bitotyyykyky87s9ef
X-HE-Tag: 1790236659-22812
X-HE-Meta: U2FsdGVkX1/QjdRl0XNMzU2IZakRcAYxlQ2A57EIr2D0PVzaOdCp22iH/gO+Eq6gWVvOINVHrPV/zOGdoICbT/yLZoCKAlOl3KXCkK16PsP5AObmu4pb8x3pyiNM81hdNKcbp/t/Nu6ZigRp4ZQXGPU+xQGr3i+fbfsDQdlVMr6PgdzMDF0CjOxJeQiNy90rCGPaP+4IrFUoTah5Ye2hR8UJhtTQWtZEesjwci1YCSAo9xdEI0bXXSduPbGkkcYscN4BBdiR9QJoKJdqEIM99WVQdzreVsvqI7ApJrozuoHeYmAwtv90q3eqTyTEe7AmNWCITwYkRCWkSYHL5yWhlLUlSpAFLpKQgfKhS9Z1HHu6VXUCKw/BDnAw41StMsNbtzBLEmpftnDpImQnF0Aou7Tjq8KtknoNNLPN3roUb6C6oiB1fsmg86CvNE4vwfoJZ2P7/ss8x0z7eyp1hmdiTipKoV50MOM1LwfmaefTushNmjUfeXzzV57zBOAB9EZ79jnXEUuMQq8pPYllo9wsRloFm0DaTqycqqoOhCSglkWYLC9Ct7MwDwpl8gig4ISwPuqrUvFDzhQNprjNvOtPDslvymb/OhO4DigX9jioHAwiM4koFWq7K9ArEV//D223J4UXlrg4e/geZjSG2PEIqO9NkZTpE2vYXYw3fvkuB2ac/V/L0aawRE+tXtdwd784d6ehCty+jUSWBcAGitztHLroKpqWL10H/NEyOAzD0Jx8eifZ9LnCvaVSqiVDrxU9Je3cfwYbor/vmSoVN/TpMv7OTlSBYo14q+c20iRqDMTLVqm4DOKZO4GLLQSqpQgSeJTRwzz3+z1fmiEuZc4CA2vrYCVGyhDpUvY2NmmLy2nXLUmL5y7n3kumldJcxFX1Lk4n8ZIBEB/1aWmCZUbAYzw7gUk74xNvGdIgi8aqbFneBL30zM7Niwm4cxfngrXi3sYQDAJGLdD7WxGcg/O
 dy9PxalW
 uliz9S4rylrzQXuGEyUwvgL3JW8hXe3jmt0v9fKRuvZafjYIipNBFSYabBHXnQfFizw09V5ssMTHp3ZMoRedUr5Y4B/0C0ciKd1L4y3XRrPugfo54rvsPOcw1zDhr1R4gaSVnOWETVRyp2HYPErVFQ38E93d3JDu9rHyLXtNI1Q4xcd5cNtAQtvdpRSo0dU/8R9SrugSrqYMgsSqDqqGDDFMZu4FP8XJ74hP6TeU0uQGCA3cTzejYGm00CjpRFBZspr/2i7PUTqpssUKBWT/LsO2fL5GCo+HV8n4xUMTW72TLEGLTSHmFS5Lzj6ZkkDWC4mMBVwt30qYUJ1cC3FFE0PjF78J8WWIaGj1x3cc/o57TMfxXnmVcQBSNfOBzH9LaoRNQ0r32YtAXJS+2kiS4h31t6X/JP6yAD0OmC/ytqLognuhsuB5YpjIzBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Just a reminder, I think you might have missed the question I asked.

On Sun, 20 Sep 2026 03:09:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Sat, 19 Sep 2026 09:07:25 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Sat, 19 Sep 2026 16:01:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > Commit 50585192bc2e ("mm/damon/schemes: skip already charged targets and
> > > regions") introduced a minor issue that causes the last region to be
> > > skipped before it is processed.
> > > 
> > > Example:
> > > 
> > >     1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
> > >     2. Quota is configured to process only 100 bytes per window.
> > >     3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
> > >        addr}_from is saved at (Target, 100).
> > >     4. Window 2: The loop reaches R2.  Because R2 is
> > >        damon_last_region(t), the old code unconditionally returns true,
> > >        skipping R2 entirely and resetting the charge_{target,addr}_from.
> > > 
> > >     Result: R2 is permanently skipped even though it has never been
> > >     processed.
> > > 
> > > Add a test to prevent this regression in the future.
> > > 
> > > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> > 
> > Other than a trivial style that I commented below,
> > 
> > Reviewed-by: SJ Park <sj@kernel.org>
> > 
> > [...]
> > > +static void damon_test_last_region_quota_reset(struct kunit *test)
> > > +{
> > [...]
> > > +	t = damon_new_target();
> > > +	if (!t) {
> > > +		kunit_skip(test, "target alloc fail");
> > > +	}
> > 
> > Let's drop braces for single line, as suggested [1] in coding-style.
> 
> I will change this in next revision.
> 
> By the way, Sashiko reported an issue [1]: min_region_sz is not
> power-of-2.  While this do not cause any real issue in this test,
> non-power-of-2's min_region_sz is not legal.  Should min_region_sz
> initial value set to power-of-2 value (e.g., PAGE_SIZE) in the next
> revision?
> 

[...]

> [1] https://lore.kernel.org/damon/20260919081239.8A3D91F000FF@smtp.kernel.org

[...]

Best regards,
Rui Yan

