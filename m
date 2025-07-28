Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C16C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 19:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2475B6B0089; Mon, 28 Jul 2025 15:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0C16B008C; Mon, 28 Jul 2025 15:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5436B0092; Mon, 28 Jul 2025 15:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F06B86B0089
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:38:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B1D5B94D0
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:38:25 +0000 (UTC)
X-FDA: 83714684970.19.5FF7998
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96CC116000D
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:38:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iTGm4SMz;
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753731503; a=rsa-sha256;
	cv=none;
	b=A51ggfaVnPr/4DaQnOsR8mj2v+AIj0itvg/ll91XkLdmRfu7uZcDy8eeFayQ0lMHO/0N6/
	nZ47+xBntVPTmAjkC5q5e//K1fbnRsVtbiyeBJExPIryMES+mFczQ4nHgojVYS9Csxu7V9
	+nscqLKEnkeBAeP3O70J5k/8ALM5D50=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iTGm4SMz;
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753731503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1B2C+lY8Ra0bLA0xRJ+Vif1wI60/oMtTqHhEqWZBaQ=;
	b=5hfECLicyFuLk5Ds9r0YFEHhXQk641h31npbxIPcSblPLUuueMtQeYw/H4a1XwITuWMUQi
	g45dly0IRQQ2nPxYnr6DqDlyCAp6+H+MKuhSouWVx1FX4mC3ML5THDq5xiE2wC1uCfnnx2
	EhlQmZrMt6os1eZMCf+2QY86UyPnnU8=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3b788feab29so1115408f8f.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753731502; x=1754336302; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F1B2C+lY8Ra0bLA0xRJ+Vif1wI60/oMtTqHhEqWZBaQ=;
        b=iTGm4SMzyPWlDXbmHf/aI3Ag5SL8Kl9fG8X4gqyzMXQTN1Y/fusJHhhowgzpB+4Rsp
         VM2htz4910Glz8gcpg6b2H/nsHrA+K2JK1SkA0H2fuBOT7VUEmKwYhsHKq391DwYEVJ1
         XDinzHDMIwC4TVUgd869uQU819vrnTu9ccUfHrNUXapiYt0HeflfDFnPQfRXInEVw4ML
         TfTuwMHQmUnef2I9lP5fqol+UwpMhBBvg4q0HJiXddTuC5IEMxahZMYrcdQ0KVQXkYKZ
         LsnC2se0vKxayZNB46MzQx7Xh4EJGh3FI3KIymQddjXECWvBPIpS0YFb7zMTMPSbrZat
         oASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753731502; x=1754336302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F1B2C+lY8Ra0bLA0xRJ+Vif1wI60/oMtTqHhEqWZBaQ=;
        b=citwEFMqq2dm1pqzUsf+pSAymz2mJQDluL3Vw91q2wFc2/F7T0YdwnK/PPGeQzGYYa
         ILGHp58wuJeIQvMIuF5agSrQupygMAtfedTHMTZefSFMMd9cGuvbGG840i36Z/YqRj9L
         nuYTkD8gZRhFg+i/YIiH9xIszllokQFDdFL+tqOo1/ZnYGNgIvKEl+wz9EUZbwpJNMnb
         HXAUhlFA5/+coJkhDVVVh0by6hJF5o0PwMLBolY3N3RIploVNovw8unU28eL3mOuXAuj
         s93IEoeDOrVhNcWGgJOrgvBggTmk+WAmogpYKTbJMaLceJoUwePhP2e2PAmUeefA2h5Y
         nzhw==
X-Forwarded-Encrypted: i=1; AJvYcCUGWm9tQtPO0s2W9l4TubcC4ikdkxyRdOkF65HxZIlT5WzQAxS1AXahU6U/MwOHCW0BUJTJzRT8hw==@kvack.org
X-Gm-Message-State: AOJu0YzDHqCEijjwxufD8M0t/cHhogMk88Xg3+y0ZL4Cugh4hn4a00si
	+mXD/GgE/rchl3q0Vfy5y2dsWTszmwyyPm1YsSmI06mKwBKoEEoS2gpu
X-Gm-Gg: ASbGnctZ1o7EbQSu4H7XUFAQKgh5447GbIbVe8HvwxSdOpDyiWCU/rLkKYonntOSYl6
	AJsngZq2St4d4tH1/EURgGQDT5Lq9Nl+Uc3wL47MQkI2rySkFiThn1H8J2Sk7/uUN3GBlGFJu9F
	yUmoMmn1HGtSinYzZ6dLCcKFy/VsWRX9WCs3RAXJu4iibvN+f8QKLQyf4BLYlNbB2lui/rUqL59
	9ceca0OIYDajur4lzmXfHwWgsOt9nMTCGgwDgF06j2gkpj7THBM5BrsNb335x391Xsh+VIepCPT
	fs3Ol3MjxWONRo7ix2JDLd+MROfxy1UMhG1q4ZozhSyyVUfJWKAd6CvN6jUEYxuspoZWVywz1WK
	YoKYapBqyleR1e4/rUyqw2XOSXbrMPZckm3PiGRJ/gemW3bs+0EpVIRHRMJnS
X-Google-Smtp-Source: AGHT+IHvIOBr6JyAvhaG41eHAIA1V3mtOhIAa1HkfuIyT7tnwt3aoMI/rHcc0qmMJHOGXfw3hW6a5w==
X-Received: by 2002:a5d:5d86:0:b0:3b7:8fc4:2f4c with SMTP id ffacd0b85a97d-3b78fc430e0mr118658f8f.1.1753731501747;
        Mon, 28 Jul 2025 12:38:21 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b77db8a944sm8455273f8f.52.2025.07.28.12.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 12:38:21 -0700 (PDT)
Date: Mon, 28 Jul 2025 20:38:09 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, Peter Zijlstra
 <peterz@infradead.org>, Ard Biesheuvel <ardb@kernel.org>, "Paul E.
 McKenney" <paulmck@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Xiongwei Song <xiongwei.song@windriver.com>, Xin Li <xin3.li@intel.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>, Brijesh Singh
 <brijesh.singh@amd.com>, Michael Roth <michael.roth@amd.com>, Tony Luck
 <tony.luck@intel.com>, Alexey Kardashevskiy <aik@amd.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Jonathan Corbet
 <corbet@lwn.net>, Sohil Mehta <sohil.mehta@intel.com>, Ingo Molnar
 <mingo@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Daniel
 Sneddon <daniel.sneddon@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
 Sandipan Das <sandipan.das@amd.com>, Breno Leitao <leitao@debian.org>, Rick
 Edgecombe <rick.p.edgecombe@intel.com>, Alexei Starovoitov
 <ast@kernel.org>, Hou Tao <houtao1@huawei.com>, Juergen Gross
 <jgross@suse.com>, Vegard Nossum <vegard.nossum@oracle.com>, Kees Cook
 <kees@kernel.org>, Eric Biggers <ebiggers@google.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Luis Chamberlain <mcgrof@kernel.org>,
 Yuntao Wang <ytcoode@gmail.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Tejun Heo <tj@kernel.org>, Changbin Du <changbin.du@huawei.com>, Huang
 Shijie <shijie@os.amperecomputing.com>, Geert Uytterhoeven
 <geert+renesas@glider.be>, Namhyung Kim <namhyung@kernel.org>, Arnaldo
 Carvalho de Melo <acme@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCHv9 02/16] x86/alternatives: Disable LASS when patching
 kernel alternatives
Message-ID: <20250728203809.7bebf01c@pumpkin>
In-Reply-To: <98BE7799-DA6C-4267-9E03-E6F68263D250@zytor.com>
References: <20250707080317.3791624-1-kirill.shutemov@linux.intel.com>
	<20250707080317.3791624-3-kirill.shutemov@linux.intel.com>
	<20250728201137.113d0f45@pumpkin>
	<98BE7799-DA6C-4267-9E03-E6F68263D250@zytor.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96CC116000D
X-Stat-Signature: u7wnzs3jt6ypw5ckk7or3xntxa3turbc
X-HE-Tag: 1753731503-867481
X-HE-Meta: U2FsdGVkX1+PenGrjqO343MKFlrpkJa7rhqdlcliemNxJ3JrR99n1l86O3wjtU5f9jFOmbGhKnC33fx5C+FWFdosMMUO+gEnVVVkE2OIPIAEhAg15nfur62Ewu0mlOCRw86lo1JnC7cRV2BRKBUOVyJBWCtyTkSRgBWgSJPxxfun1OrtqvjHMxVSfC9A+oS8dL0d1ZUhyJ4pY0/Jco99YNz0+NOJrMBk7ZuSxeQFKJ1OXTJBZ1bGQlF9+okVpgqTVULK21gckxN/Jf8QR1o86VLump3kev14EYzwcaT4LmHtzABamPAr+A+dv1Ogct2cP6AWwoO5ntNLOpQe43zU7WgN2bj6EW7a7rZ293Iz5Bq4RlP9p6BhvVWsN+qwC14eCK6RQ1s9SNMHODANGqxz+dJkAKVFQwx03V2XoAJPdLVsCxJdcEwy0nOo8Ozzs2KaAHVUizS42cZwfggfLtGyYE6Z8aatOVadjGRAXhN249RLQvq6PukE22nXVsmwwywX9M1qJwWdQvXRNe/JdkkCd2M2dhb5tzZ8sg4RRPMxP3vPALx3v8xZw4WfRU4+H4xrMV7cwBTgOWnndi/0IUb6Q6yHi9KjmxIDVKz3iWZvTKqDiHRtJo3L4GKfDZqNCwvg+JcStM+Z+C3MzmA55MbqMfmUTogRWJzQksnDRw980z4MJ8dg8+bmqXHQmSW8tzmPmi+56oes9X4WCTST5sYlvjrOTbE/GwZi/ygO5G5vceQ6pxvWbzBzqWaCnPs+5MWZ4mRoEniFkrWeWG6dT/B6UqagjjztHwgftoZkJB5pTzIDG00S7ovmnW/PAisAXynnuwqZQn3d36tC7+VwNr8BrwYa4vCjH8D8qa2akLGkjB8ntwWXmaNZtYU1lg0xw95c/pHkEaAY8DFm5JE48yrJaoGBVLT4dgVitVoqc9UX+Rjsa1UMqA7Ewib2Og0iTE6pS9oKws+Cm5tSJ1uxTFG
 IplfR+5P
 10yx3h1Q8jFVMFCYJUoCfBCrVQ8EWm7uGl5/9KOuTXEycNzV7nGsLfXqKMQ8P8OlCsez3EdwiFKV4dyhjz1oG/FHoQg0yhmb8i40Jk73xM+l+O29RfEHo6dDiQvEpVQvayQM1c6+zlP6nB8cVUNSzYgVvTUa5ihWNrq9A1HMPMal8kZWUbG396FDeUybKEOmasMQdgSK3ePWeFFUXxJ0v5WeOaQzAZT/QTIDsuoSAUt/z2OpGri8uhbgP6+1CCYF350jKqZz8ike7KKZBC6ioCMYfh2SCR9EqNuxxg4dEm9kCXNPDoRAMAeRl6mMasbvnRSN8Tojcr39Mq3M4nnrevaUAJk5QU1CFNTm75qAZz657jdV2IxGXO0oM0rVlyq61/dfw1VT7+Q0971bVPAT0KsOd8NYckQKcVrts9u5w0m1BJIbscSe6Iy7+URQJOXIJQAtCNQQHAGa0O6wO8hoEPAa86oVqnuCq+xb60km9jZGEMDCM6xUV/4QtxW5NK8vn7d3kEtS/CEzT2a71QaMunjKhhSr778gx1RaQafhIAn9/HRUPt2ToZl01IRGTdk/uSPHaK5yWdIMENv+HeAKQ7iWMKd7G6U4rXMukBKMlbNsVs/g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Jul 2025 12:28:33 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On July 28, 2025 12:11:37 PM PDT, David Laight <david.laight.linux@gmail.com> wrote:
> >On Mon,  7 Jul 2025 11:03:02 +0300
> >"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> >  
> >> From: Sohil Mehta <sohil.mehta@intel.com>
> >> 
> >> For patching, the kernel initializes a temporary mm area in the lower
> >> half of the address range. See commit 4fc19708b165 ("x86/alternatives:
> >> Initialize temporary mm for patching").
> >> 
> >> Disable LASS enforcement during patching to avoid triggering a #GP
> >> fault.
> >> 
> >> The objtool warns due to a call to a non-allowed function that exists
> >> outside of the stac/clac guard, or references to any function with a
> >> dynamic function pointer inside the guard. See the Objtool warnings
> >> section #9 in the document tools/objtool/Documentation/objtool.txt.
> >> 
> >> Considering that patching is usually small, replace the memcpy() and
> >> memset() functions in the text poking functions with their open coded
> >> versions.  
> >...
> >
> >Or just write a byte copy loop in C with (eg) barrier() inside it
> >to stop gcc converting it to memcpy().
> >
> >	David  
> 
> Great. It's rep movsb without any of the performance.

And without the massive setup overhead that dominates short copies.
Given the rest of the code I'm sure a byte copy loop won't make
any difference to the overall performance.

	David

