Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E2CCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 14:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CC8D6B0096; Tue, 23 Jun 2026 10:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3556B0098; Tue, 23 Jun 2026 10:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E24F6B0099; Tue, 23 Jun 2026 10:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 344A96B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:03:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B19171A0500
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:03:47 +0000 (UTC)
X-FDA: 84911345694.03.44D66F2
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 259971C0026
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:03:37 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782223418;
	b=hAve6L3Qr05kcq7FX/eHSUH9/HWFOnZZglOQIgsuk23Jb5NMfwAu4ZHcLgTCLLyE4AgOWR
	wDONJoYYRrMlu1M009E6bsvxvgpsBzwpt4PT6ppGz0Lz+8kYSf/NcCoA7VlXArGX3/iZvF
	Lhiqm9XbmofxxfOas6qQVIB4Gj1AZU4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782223418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pndzfg2mCWavHm/LZE4HxmOjSPKqkdyz2Mxcm9023NE=;
	b=08/e8xPaYXI2FeKrDvfGSm1lkpZvxV61e6Hu0tX1ZeJdYtqapsh9/38ahXvD6W+ZCJDFla
	Dv8SSHFxCQsAbPEcLhV6DI3jwREY1EGCwoTFevp3bCGehO1sjLEWDk4LtvOD4qAD8nKhoe
	85zE2Wr8ptj96V4hii4qF4FUj5nJ/8E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bjnWE90I;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3N5I6agkKCJ4R8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3N5I6agkKCJ4R8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4924e099a17so13500865e9.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782223416; x=1782828216; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pndzfg2mCWavHm/LZE4HxmOjSPKqkdyz2Mxcm9023NE=;
        b=bjnWE90IT7s6nskcpp901wtQ958ecYWPWSFVF8guzAIoXGrIglT1pgDYKNuc1jhaW1
         r6C1OLWGrV5zhkk3PSDuKBfd/b35CVp1ETtoFTjiB+4BfJesk6E6lrkMK6khjvDnJcAj
         wfBNKWzwc9KWv/n+XSX2Rm1gFSd8ozpA2ULasnx3vLoN4P9o1Q60ZEJRS3T0nl9DKL4X
         f6pR8HZVHpZajzpc1PJxKG4VAvQcCYmdOJ5M4RPhnEeginkyrEsSiEzaXTb/AIFrWNc+
         6mIqqyP5x/ykR+IhF4oFFuCZDO4MT/cW33xi9OAqX0txSsIvHrHl5LYRukwEDh7j7EQQ
         k7rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782223416; x=1782828216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pndzfg2mCWavHm/LZE4HxmOjSPKqkdyz2Mxcm9023NE=;
        b=p6m4J/R+NtIeUtALfLjlVNluB7YI97+KtnA3q9/hFqwlLgu/TGPAXuE3VFyyVV1O9b
         468IB8A7D68zlbeEFmEvJJnSfx9dsmdfOfJ00oIJ0He8BcWppixh2XX67Wy07CuNiORt
         TkiPjVByozj5a5fhgshvQkTRjNOgvL81uez4dQmn/uA9a5m3kyEbBIu/GQpAHKwpqVJu
         tkLcUO38Mv5Ni25xYGr+wPswXumMApiPwbDXISazx0yqbid+RjLawf+JxebRIen9ge3F
         f8rOb8v1yxoTl1lvB8BYZg31//l5CAqkbSQ0sVbz+aOp/VDwK6ExAVcHzbEJ71qQMfUX
         T24A==
X-Forwarded-Encrypted: i=1; AFNElJ9q8sO77Z2YsUPXR2ImVAi6cDJAIls8mmsetOnhF5afu9ZQzBjLdnk5380olaANQN0BOLUAlYtERw==@kvack.org
X-Gm-Message-State: AOJu0Yzflmg8W8bz+VakTn20xXD1AgdnL7yW4Oikm00TpyaAjLEgzQbv
	dPkVh9O9oG2Ugo0Ux/QgEPr7znzY2z9Ya5TDdq7fEg8wP5X1JBQ6WFzWyBRSYaDEsqGpXR0/9Bl
	lbOfBDQEP5gtPYRmQgw==
X-Received: from wmo12.prod.google.com ([2002:a05:600c:230c:b0:492:346d:8d96])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3f0f:b0:492:3214:cbe6 with SMTP id 5b1f17b1804b1-49240e7f6f2mr330026535e9.23.1782223415994;
 Tue, 23 Jun 2026 07:03:35 -0700 (PDT)
Date: Tue, 23 Jun 2026 14:03:35 +0000
In-Reply-To: <ajnOnzdknfwbuJ9g@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com> <48777f4749fa43d5648085dbb2037aa99c144a88.1780676742.git.tarunsahu@google.com>
 <CAEvNRgFEHciT3T9y+qEYRvXhDwfrggoU7Rm=f9hT3OrV+wgpNQ@mail.gmail.com> <ajnOnzdknfwbuJ9g@google.com>
Message-ID: <9huzwlvpmk08.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 06/10] kvm: guest_memfd: Add support for freezing
 and unfreezing mappings
From: tarunsahu@google.com
To: Sean Christopherson <seanjc@google.com>, Ackerley Tng <ackerleytng@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, fvdl@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, 
	aneesh.kumar@kernel.org, skhawaja@google.com, vipinsh@google.com, 
	Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, dmatlack@google.com, 
	mark.rutland@arm.com, Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Graf <graf@amazon.com>, axelrasmussen@google.com, linux-kselftest@vger.kernel.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-HE-Tag: 1782223417-692627
X-HE-Meta: U2FsdGVkX18Eb3J4bCar4WPv4eRBQD4a+2myuzuWqxjH+tWqmxko5VHc8UC95veR0Y73P63TSim7nCfOLIHhjCZRmPjinCwoq9vSLvM3xDyX4hUKwbigwBWI3DWajPSs843E9dYqCgABZdBlEeu2zcoH9KDcP5xI9LciGjufExVHh3v8G84iZsYaY+FjxyuKObKRwJ2dNaTuvP2gme/ZAbwIRkJUrtiHAt9mm56YL2h2dOPezAz6JtYP+TItHmjW+/dKQCxBco+YhG1SvpKHuAzflyASt/cHM9/+5P7+aPAvDwqn/5gMxO/UgIMIjZiC+qndrZVpZGkuhUMY8SpOyuVdhI7LVAFGF/6dftXjUjyYoNnhspEV4UyDrBub25gt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Jun 22, 2026, Ackerley Tng wrote:
>> Tarun Sahu <tarunsahu@google.com> writes:
>> 
>> > This patch introduces the freeze on gmem_inode which prevents
>> 
>> Can't find the reference now, but commit messages should take the
>> imperative mood and avoid "this patch" [*]
>
> From Documentation/process/submitting-patches.rst:
>
>   Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
>   instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
>   to do frotz", as if you are giving orders to the codebase to change
>   its behaviour.
>
> Documentation/process/maintainer-tip.rst and Documentation/process/maintainer-kvm-x86.rst
> elaborate more on the preferred style (I do most of the guest_memfd maintenance,
> and so for all intents and purpose it's bound by KVM x86 "rules").


Thanks!. Will take care of that.

