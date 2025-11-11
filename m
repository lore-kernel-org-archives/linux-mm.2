Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CC8CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B7D8E0020; Tue, 11 Nov 2025 04:23:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC078E0002; Tue, 11 Nov 2025 04:23:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB0D8E0020; Tue, 11 Nov 2025 04:23:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BBA6A8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:23:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7132113B0BE
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:23:17 +0000 (UTC)
X-FDA: 84097787634.21.16ADE97
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id A9DBD180011
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:23:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LOANu7zP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of glider@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762852995; a=rsa-sha256;
	cv=none;
	b=Sr4Qq1DLh27+Qaq9zR73QqJ+kpAVauJiFn3LWc2WzlhEU22c3MbeQJRdB35tru5z3LwzVE
	9Q9qV/9L6QfKy4fevdnYiY/LRwunzH/sC98vRZf0cbuSpZo5mKbzTDejv2Or7zFoXf6hgV
	mz2vX9Z88oUgee9oDi/17cwT88dxS3g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LOANu7zP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of glider@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762852995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HW+BHIjHuyTX7OAC9AGqEECbSB0U1bNiaGYXhX8ud1c=;
	b=qCLHmjL6c0ZLHcp8WiEeId5/6ra88wjYQJy2YSDM/ogzpHsBC/z2x/Hn5SUT7d4owvrJiL
	Z6vYCtp+n1m+c9+TefCoyCmK0t3FvSPoNRnbvePkSEetJbfBqkDVMn43CX2BSXlvo30lbd
	zOyG+8cl30vERZPNHX9+zYLBwv5iu0s=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8824888ce97so28487336d6.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762852995; x=1763457795; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HW+BHIjHuyTX7OAC9AGqEECbSB0U1bNiaGYXhX8ud1c=;
        b=LOANu7zPH36eIUIqAeMmyeGQ+xIBZVsl63lJ2yYVo9Yj29LqC7pZpBtW8dIehnpZvi
         x+3tDLcSTgfka7jTW7sFYow/QpvP1hVrLpjrg+nLkFbhSs3Gk0ebTJcyd5mAXnV+W9yC
         hz7oqzKDDhJ50RMO6ClCj/2tLAk+WbGmTILxSmAHcjQTYR6xb9fVE6baQNrJPQIDb6EH
         cf8Yc+e3MPK+q/fDPPJ0iSw/D72BY2kLEdMnMi1Pwxzm/9gM8IUNIsjYyFdc6vplNdMP
         fwQnliTeGptZ2DvVuU+xKwssW8c876OUtb0OThQY3FkpA5zB8biqHbD97t27ECXTUF+N
         k3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762852995; x=1763457795;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HW+BHIjHuyTX7OAC9AGqEECbSB0U1bNiaGYXhX8ud1c=;
        b=V9sqM4OLtDfHsFZW1Fc6Wvl3T9a1rnU8tuoBQwSC+TfcsbTO/JtY8TLvMKYDKGFURs
         Gb2pAe3oTGROcVKZkwS1/6bOOVU5PXTmx2nCf7TdGk6zkzdQtQCridF+ZNja1pOso3Xh
         +Xi7l5jSPmz5OKJ/qmnWSdM+uEF0WWXrlofca802YL92B8/Dsk1ISOWydtDLCbLfWt58
         9hriaOiCkYj1dfTTLPk0asO21+ubNTK26QFqLQm7klY7ADLEsaz9OH8neuaGb95JPg7s
         xFc/DxtDU+CCCbXQXB5eXJYGDfiArMVdBqqf5kudI01KLKh5yKVgjBm2SaUK8zzYIA6X
         eQNw==
X-Forwarded-Encrypted: i=1; AJvYcCWkytconwpEoIG4evHngKu2MscUkgKkF05Gb9YCxeYDMzxzIgZcGKllmAobVKdDtdzq9Ck1yIwqxw==@kvack.org
X-Gm-Message-State: AOJu0YzQmEbL+i9pNG+lzy2NnlexhHG5pCn30rDh+V31e1ItYSAZECuE
	jpe1rWjlc6MKZwGy+5KvEqRFBwCD05KXZ+BS1Xh0V1XOD4WXmG+7gAW08ZuK/qqUKyd2lI8KZao
	/OR9mdiH8J8mN1fijrP5dUEO5l0B56hF5Hm6Tp+xJ
X-Gm-Gg: ASbGncsJbYBTvoCheMIGGXWKmnnAz3SrorZ2wkAqx/JSUMvxbh5SkwNEgwekPoyekr0
	ED8w1oVcVbpeIhmaZwYlMfu9O41b82p0zezCR7GIPT2ToLyGUz8etQaPJovBG4sP5yMas3a20bK
	OnUD1XJNuDBvKSR//rQCv/wLHorMl9zu3pYhaMkjwU/iRsVREogtECSgdoL37Ycse3ggrGyCaSQ
	LaK9xrlAUfx1MSAqB5lo7He1rrG7BG2aQThqWFBDHD8H+cgkdh7Ewx3bm4QgsEPqQB0y8V2TEAn
	mJpsxJeoSgtU1xMCxocO9JH+YQ==
X-Google-Smtp-Source: AGHT+IE0yzs57LETS85djEZyTYXW5DmddvlcMHLtxP59+D7EFGLVQ5m9xCUc4smiAAZV+t8Cn2za8HGBMs1SjTj1Y9o=
X-Received: by 2002:a05:6214:1310:b0:880:3e92:3d33 with SMTP id
 6a1803df08f44-8823873d584mr174202246d6.34.1762852994390; Tue, 11 Nov 2025
 01:23:14 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <8681ee6683b1c65a1d5d65f21c66e63378806ba0.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <8681ee6683b1c65a1d5d65f21c66e63378806ba0.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 10:22:37 +0100
X-Gm-Features: AWmQ_bn-gtNt_PIr26xFMqgMDiPlRCOzgcJVubPfw4RNrG4hXg8UIUOVQ0zkb_Q
Message-ID: <CAG_fn=V46UeEvrPb01VRk+60-wL0DA6Y6ZD5HAfVLzHcgRh+VQ@mail.gmail.com>
Subject: Re: [PATCH v6 05/18] kasan: Fix inline mode for x86 tag-based mode
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A9DBD180011
X-Rspamd-Server: rspam07
X-Stat-Signature: 831nrgappxqc6s94cig6cjsephpuy3cx
X-Rspam-User: 
X-HE-Tag: 1762852995-948334
X-HE-Meta: U2FsdGVkX194dm4wi0n7eQx7FCf9HseRWVDtiYm3CAekI8jApwDPzZPGgopu6MxjbhazinIHQ56FXVR446fSxb35aqTtQy8qdRgPoJHmXnNaXb3r5tTfVwH5eByoD7ofRCv+C3UkXEX73eduDElx67CbGuotgJ8M7UuXhp1aS709MVOZCP0GBsga9CFQM3RWGumSwt4EyHq4vYD0bc45b3fq+WO5Bis9pjC/P9ZziHC3S9Z9cCZ8ivAFdqKGv8capAeR9ArK5MLSTS55Zfh+2YkppwIP2qMu4COLUJg4vCWN3y+FYvP5lbyT5cCVDiYZUCRRYnTpZ/HTUu7Dx8V7jUq/4jAre/MhZNIUHfsmuiainU5ViQUNVPBwAfrB2/iPKThUyTzGEoSGWRz7ChuEglao1tKMt3OvU9185RaeAoEWJgmYJQqd5g9w+zRUdsUoanU0nXwOX1BXuHEB/RBfOu5ZcrgZj9pujDHTCQnEj/EVOHjEKxoezAgl3AW04yQWTS50BddF8UGCnNf1jscXl7YG31YS+AVWP9m6FtaqUDZYTLyx57wJbSFF+stAvStL4zWUUMbzSnsuFTYq44JR6NJrkw0E1wL2GbaOnL7y01BOOYGu7pOyanUwlOwW+V+72bbAHVSj9CU++j/J7+TOCqjNT77ixzjh/YrrzJe9j0SlRpXVjgPZVrtZ9GjMSDYF6HYCGsl/JkuDwwVTA6BELabNeOzs5hUs+IphRGrnMjVs9whJqA4xUGk4gdE6O9Zp26kKNRmcTW1t9YeEFegnuGOlGUK7e09wPm9FjGiG1j3gkJJIIk+RffyylygXifBpHq6w3GOPZAIokO2pIStfNS89XNmxk64NGV/foaFi4HWBeWGlZUR9strA/kKfHBZmetKyLSaL5u+FV96AgoMuPjxexU7b51ccXuLLULJ9W5E0vn7tYf5fACjBBU48EFyToTbTIaeXkHvHAPhVHvl
 oUwbXz2v
 fdu1V5qAYunlqV9+Wrla127IrBCFsZg9uQcfDP5jXlY9foGXyH+s40xBQed5+mjKeNto7+v7uJ6xBarOYsMEa63YOegKP0aF4C6beXoRhssXnuz9Jtu/s7Cj9b4Bf+8wfdpr3wNMgy+ZzPtlI4XRFbMk2EnjgsxCjNVMPH/u6abXJAs21FKXNr/YvjZWe+UYcRVG0yTeZ0fCZtzrD5MuqFolAKdrI4qAjKDubJlu1Njf9bDGKzL2+8EjsczigQq6vMkiV6ziZJ+1+gUni+Nc2QE5malDGa+v1qGGX3YpbSAwxsqtdt7x069r6xAQan2ZU6mcYs34414TIjwV07hFi1mIqRHLwTBmbN5jNxCn+6RZyAs8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> Explicitly zero out hwasan-instrument-with-calls when enabling inline
> mode in tag-based KASAN.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

