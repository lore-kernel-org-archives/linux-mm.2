Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 583D6FA1FE0
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94E9F6B0088; Wed, 22 Apr 2026 14:22:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900216B008A; Wed, 22 Apr 2026 14:22:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8169C6B008C; Wed, 22 Apr 2026 14:22:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7420F6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:22:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D129C16C3
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:22:51 +0000 (UTC)
X-FDA: 84687012942.29.64DF32E
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 566151C0013
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:22:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UMwlss7M;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshlaw48@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=joshlaw48@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776882169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sU0Rm+oMGaRD9pxw1RzRkjemd3P7zS8oqneye1M98P0=;
	b=R+8fsLB93t9O4xu+N1w0MOHER3KMlgfINWSTXGciquxbDy9Y2uxTAMo27nfPed/t0RuiA2
	FOvaMvnWgFdVS1QtuSAplU7Oww5k9qhWkvSnUgvn/N1UlrzT5I+MHlR7B2CXl3d2TfHVGw
	N/bBa+ndehjFCn7lhH4Lb50CZi3p1C4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UMwlss7M;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshlaw48@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=joshlaw48@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776882169; a=rsa-sha256;
	cv=none;
	b=4jR6mgbtbpTX7fExr6ood3BVppJzarOc39AGIs1rm/UjtSdxFng3HXBI9/sSrJWjmslbWg
	bhdz/z0+TzMoc1AWI06L1g6ce6GUG/hUl8EOkgXq7y4OaZOsF82yGAKCnqklrX4ISrh3J+
	9XD6BzlvTw5SCEUOl5uz4q5KRY3xH1E=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488ab2db91aso75544705e9.3
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776882168; x=1777486968; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sU0Rm+oMGaRD9pxw1RzRkjemd3P7zS8oqneye1M98P0=;
        b=UMwlss7ML40T8m8MOttdzCYudGFtnl13l3ECJvUJ/9UJ2Rfo4QbRp2TlJEvAewRr3j
         rFoEgDrfUfauO/rZWw3gRNQZC388olc61Xn5gZ6UzupX4mmcBXG85yyeYzqpoy1ZMWDu
         gtagYk7Gv7KoU+mVBaYKeyANeKB8RFLK8kGsji/UKGkzvsZ1kWqKBC/HSKzjbS84dKe4
         j8UeFpKQ5JDfFlfz6hMS+QXRSI7Gf2doBRtRWMc6G2IRZf5tSJIcnP+pOGmeT9MO1Rpe
         aDJJtTTDYRXoCV7dRqb5z44M+ck/q3SWAJCp45Y6k5jsLyq70xZkx7nEKoh/Mw1phyKS
         bCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776882168; x=1777486968;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sU0Rm+oMGaRD9pxw1RzRkjemd3P7zS8oqneye1M98P0=;
        b=Bx+ELuZ8dgJulOdIhSyo6Q0Agy1MY2stBQSyijSBVzq30SeZwj6Y1qbbmADEC5IPta
         Ho9gVTRee4PtJHeO+xxyEPWCTC7zzBMrUwKZAmpiEnzWe2QFyDi4Y8Yzj+uXNxEhwnUd
         H/Dx7hRtoREmdb1yFVAriua1ZargLfDZayD7XBj4nPVtC6SEj/0WMOd0oUqK8RfGayKa
         NgaVEBYvnlXjq4DDT8x5uEYLdm+9uBXFvtVpvP+kn+LZTVnJN/6rKeZ6xY2bmJKT9053
         hQVDuzp1fNv5qvGbhSqZzwkK8VwARHuqzv7d480rYHOeQwaedEV5+AzMSSJXR1Cv8oHr
         22TA==
X-Gm-Message-State: AOJu0YzosuNddSVbx/6Hl55nbncJs7Cl5N7oRhUxjOjGis1SBvaEe437
	PQDNBJ/fFL2A/qMGIQMR6fH590t+b/UOo7Q1NmyNLfnODyl5MRdY3kPw
X-Gm-Gg: AeBDiesNsNVR/xnBrs5HaZm5rIYcifngWakUPwcFsfi0nnmGeienbmzTu/GGx1O0vew
	tasEV+5dgw9XJSMzl5vkAaf4TUyfY4TwyE3JKNn89ZSzvn3SoPwdxGLg90lKKOw5Ep/8hAT8Nso
	KtMdGXtZ3AVPRAZmmq7KImSd7DbpAKOpvxzuN2A5lmlzBYXp3pyBhZ7g+o7E0qOQn//pBWylVru
	/mR7NucIuvssxjExnrRa1QYviRuhKkBdMKSHTOmoa5fxbO0ew1gQ13El4qZ+VMPhFR6QKBDlW6M
	ykyeePxuh0VZSVaIAdGmBvGsddF4fLYhuGvXDzd3bSESPexLZvxjTavXYCEWkAwzd5Sx3lafXJ1
	AD34w/3UTIDQT94yFVju2fAIT1znLV/X33x3fGr4hqNXOtiODn6qTDRVeOKqiPQ+QfrMtBqexyn
	sau2fJt4qbYv2/opcWMm2eIofd51pMcqH7a+B+EOlZHQ7U7YA=
X-Received: by 2002:a05:600c:64c7:b0:488:a2ac:a334 with SMTP id 5b1f17b1804b1-488fb73aa3bmr358386695e9.3.1776882167602;
        Wed, 22 Apr 2026 11:22:47 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e59f97sm52509074f8f.37.2026.04.22.11.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:22:47 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:22:43 +0100
From: Josh Law <joshlaw48@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
CC: linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] MM transition
In-Reply-To: <92c3d650-be80-4a64-a962-3586ba753316@kernel.org>
References: <16B7B5A8-EEA7-4580-A565-3A0B4DBB08AB@gmail.com> <92c3d650-be80-4a64-a962-3586ba753316@kernel.org>
Message-ID: <B2261993-3CF8-47EF-9F76-FABA6BB4A50C@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 566151C0013
X-Stat-Signature: qojh9kwfabfynfigij949w6zupychuyx
X-HE-Tag: 1776882169-562990
X-HE-Meta: U2FsdGVkX18Snms4+GlzNk7h9NV0nY8fb+oCC7+xP3e+/IFmNLZvtdlPAjXvhcL3TUbmskfVaIf1XqHxKHziTuiqifi2ueEeqenTxSP+IrpcHnGGmldGtQZA1aWuQVCkgCXrtRdfyj2RY6k+7HWavydYEYy/ZFpvZY610ExZsYWUfN8KMvuhWyJw/ocK+HWjs2bfYPO3EXIiqZLG3XlbnqwsZ2vnvvyG+Io9m5YW2uCUJTLZe3k++a1s2dZgpYuqYiIgmChdLLqdAPhbzIoXBIH0mNGfERrGBA6qChOb6Nw+rVTMjirILbbC5mILlXiA8xuQK/KouFhbak/hgJj9BGAvtLp9m+jDtIhG/FyHNmqoA3UFYJ4hiuH6PIc5JuuwdMF/uRvlTc30Q09ggEgidAZCXYTau6yVzv2gi8brI5jqpehXKRRCYFRgDEH15NTwCt4zreota+bQ4FxWSlnVCmlV1Dbfq0uXPkIheTJAlDvwbftYScQJOFWNg9v5ZwJ5cWfMErUCe0gq1JF35mVA75PlnNUNYz7a8m7Ogi+YWM0zh2vzX5e0xh2IU3NYasadfckmWR1WCGqxJJ8wtzpJBFHXyxRicP6uzUQ3gzozBuwjYt3QMkQJ5g/hDaRSWvzX3QIFeFyqs4+E5+F1kIkdCd69I5BQTxhTXrDrVxi84UeGuHo86Ixz+35Yl6Zpp3Hpkv7SwoPpZ1mBEM81uFD837WVPh1oIPYDOulyGq5/Iq/7vSAJ7PxOXI6rppKxTUlGJCAWRWjNMz/JnyfD4dslDF12S2CTDqkuGhzSpC78064LxfIpxkyLvvpDoETJx8FRnnqGuKQwUi5+UXDgGEZuMtmQjIkMfWpu83s/HjrbqSBeBKGKXSGCnTZtTNU/fMoor5eiSlUcC8J2jVhn5Tt8ZuGIhrZqbLjHA/IzCrt4LaLtU1zKURKmk6tqVC7eeJq86Bw9/w/t9l0S/eeltL8
 51yta0Z2
 E3xuKnQPKOlCBDf7CkHnRR5QfA6Q6h363U7AG27505DBx+LKYBLYvqUuG73qednPOjauKw9FKBtQ83U3/dt1yy5sXOWE799wiCFGEzHpmrG6Q6iq7a6oCeSQNT5keW4MURko4QlDzIJ4CInAmIYfDDEZN/q6Nt6zIDp3BucYO8J1AKV2tFwARazFa/JbefQbYm3Q/xhQx735IGzd1YFQcyLLa8RtmqsGse0e5pHnNHHWot6z0TPqjWo7jHzfrFX3cFXD3BzX5H2I7x+j5Igvzwx1Ek/PkoUm+000XLTHZg0EIca+g8NddSzb4yOGT34IcNaeAngkQodAAlgpvoBeFFqtbrQHpwRVsBjzl04HhOkJGgFGBDe2176hrqNlcAuSxmbjpXtxog8isTnIBWvpeAxjtDLAA/3dttkx8VyveIDfqZ4mGWo8nFcgeSiHjjVLnniGbagwUkcsDl9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 April 2026 19:18:25 BST, "David Hildenbrand (Arm)" <david@kernel.org>
wrote:
>On 4/21/26 21:25, Josh Law wrote:
>> Hello, since I'm not coming to LSF/BPF because of my age (aw)
>> 
>> (And I'm more than aware this post is more mm focused, but I'm
>> representing lib :))
>> 
>> I'm "virtually" putting my hand up
>> 
>> 
>> Whats going to happen to lib/?
>> 
>> I'm aware there are submaintainers for some files
>> 
>> E.G: Steven (and Petr) for vsprintf
>> Masami for bootconfig
>> Willy for idr 
>> Liam for maple tree
>> Etc
>> 
>> But let's say, lib/glob.c, or lib/bug.c, even lib/inflate.c! (And/or 
>> all files which only has you set as primary maintainer)
>
>I'd assume that (excluding MM bits, for example) falls in the foreseeable
>future
>under the "I plan to keep running the mm-nonmm branches.".
>
>What happens when Andrew fully retires is a probably a good question for
>the
>future :)
>
>

Yeah David. True, but nobody lasts forever. Andrew is "stupidly busy" (his
words ;D), so the (basically) orphaned files like glob, or smth like that,
could go to someone who understands the code better and more likely than
not, has time to review.

We may have to have a think about this.

