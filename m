Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F48606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=bq0fl1Ms
Received: by kanga.kvack.org (Postfix)
	id D94736B05B7; Wed, 28 Oct 2026 16:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45176B05B8; Wed, 28 Oct 2026 16:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0BFB6B05B9; Wed, 28 Oct 2026 16:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5AF6B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:37:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18D03C0117
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:37:08 +0000 (UTC)
X-FDA: 85373194536.24.F7BA1D7
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1EA124000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:37:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bq0fl1Ms;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793219826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXX75GaXTMr1qGEscquEidPOCC4V+kXbyCqTlbWwNJM=;
	b=5OoZ9Z3vChHvw6kCjwZ+eGPTGjjREmG14yV06Uo1XiKn3kePZZcutik1Nkoey4CmePfL4E
	Grn/ogc24vOK2azxIzHmdwX3HRa77zDQBv7nYCM+mIiPB4zYX9d7C5HDLvWptkbN+jGF7W
	VLQiUgr4y6Lbb7bkgQBZmXhk0Uy65Kc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bq0fl1Ms;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793219826;
	b=fjtl3/zzJe6xG/wueOWfap2cNknD1uxtUnyyFJ8toVGEX6jzElJedzdaw9wV3CFZ4VYGul
	fjGSRQ1grRT5bQU04cDpMphhmC3mrPWn2/xO2qprDpTH3IAGskIocQXNb42/TgCMTyFERk
	v/Ct9OmjjwEyzG6S2hFoxqNRpKRocxo=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5ec3561ad39so537492e0c.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793219825; x=1793824625; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pXX75GaXTMr1qGEscquEidPOCC4V+kXbyCqTlbWwNJM=;
        b=bq0fl1MsjvE2/oikzO5QMGby4q/YwB0hVHEM6DUG5LI5cQVJC6SQYwHUCe0vBdkcDV
         cRY8Vm1NYIcw4ICvm2VwLQ3ZaTiCk2VOdF3sujNjLocdzOTPpKLXlTLGcnzl01gn3Q/w
         1L0bX7t6lCJG1pjm9UrPOD85HGX62rJBhs0AaHpm2CuMUZim3rwiKYGBptxoGHYxLNJZ
         90KPN8sdoFNLVkKMGIZ8MzTMLTNcmTq5mBnHSuto+7yhyyr5vX6AcG0WEQnVtTA0lV59
         gISNcRBtyaaAzqtNsvRRRWyqycnKsmGoxFFKVBHquyHgvEv6sKPUeHqa8P5xNOz99Ylt
         DH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793219825; x=1793824625;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pXX75GaXTMr1qGEscquEidPOCC4V+kXbyCqTlbWwNJM=;
        b=hUyV6SGP9G5KnkMB1x4CCoXsckWhZ3NPCrRZJllRnIgYWEacw+2zLN/DfpxNCMsn2H
         BpoyrW8/4lWMWfgVlAKZD3cy//PZIb3IFfiVBJ28LNhDx8sqwJ8g9KESc9CALMKAuUZW
         ctrYk7VYlSQNPDc7pAVEFWipBLtFqt0oiWUB91+PuF+TbMlNwTLhEKeSnG3GDAUv7t48
         I0RB7FTaWC1ZYg8eWuWM5rQPZhJSv/0OeW+gMVJkrRtYeE+gnRQH+57Ad6QTJBLkIjbr
         IGGSgDw7oqVt2cIh76a0i5BEJNqLudib8xcNqwF55QvOb05KtXtsuqn3rrHbyM15sz79
         kVig==
X-Forwarded-Encrypted: i=1; AKwUvBwcl9pIwfFxsKBp3EZiWGn6f/i7kVuokfPPK5cLF5q3F+IFSK/CMjok3OvgaUodAtJVLncchaiBxA==@kvack.org
X-Gm-Message-State: AFq9FYKar2Zyh6DzpSGEGERRGiyqUMKd2L7Ibvx+WLbF0AMWi355xnEi
	8py3b4FcpBkLwjD14XxXTjYSKCMC2iVuTC2o97hoUw9geeGLEAzR1/cQo1JZa0adZ4U=
X-Gm-Gg: AYBFou3c1liDOXyfEPR6wlwnNwQiY9LN2yBig2UO9i2u9tdARTht6xL/+GOp/HqDOuH
	KAuEHgYuc+eMBasq+p3s1EezYiykCQtUqXXKomPLLvmggwW7o3KzETRJTEp9o4ON2ktw112LuSs
	QVBelP8kSdUk8uMtU52wq2RLA0JZeqx3Q1sV/nEGR0ksv3NpYQIn9qboYMCzY4dJL3FgV9Uprfd
	TOP/jNGCKH0/2UregX76RRUO9Mrnl/WTZUZL8GGI3gGIxTFIfjwHobJZB74ag3W0a0yVE9se9Xn
	PZ+NbSrBxv6EpC9OZ7FtnCjNmqeb6eHHfYBeNjbQXjfceMdF29AuoiCL9fUrSOxv6l32Qkj1d9Y
	7MiGM3gnmhn8Ta+rXVwTdirOI4/GhXC8+gdcpVkGlQWknFfMKNQ3oifAYSUN5sQSI/VurNb5vGm
	OeVqSRr275/80cYYS2udDXLjoYncghlYdsN+70tTOS1yi0oXvQdMc0h1QWjWSlLhQxAlpLPw9DO
	rxZMIIIZLb5aIW9qVZp1LSBjVEWstvdbFRIRTPNkSSfTvwki32QftC3osq79hm8vHP83oCUvEXR
	82AtUwBgIjGBjkJ49vldZbo+qc4Ljz+FIrRhGTUbAuFXxVV6qhXAod6Q7cSkME8CZt8R9if+u5I
	16aTIy/F8rEcrmOmcChrX4ARJztOEMiAC5NhqpVtO+n/6P+3g6JZecDLPXQ9nYtE6XA==
X-Received: by 2002:a05:6122:d17:b0:5dc:d0cb:7d74 with SMTP id 71dfb90a1353d-5ec4caa66c5mr1844102e0c.2.1793219825199;
        Wed, 28 Oct 2026 13:37:05 -0700 (PDT)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec4f931911sm3001789e0c.10.2026.10.28.13.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 13:37:04 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 05/10] liveupdate: Don't WARN if tracking a
 retrieved file fails
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
In-Reply-To: <20261022225035.377445-6-dmatlack@google.com>
References: <20261022225035.377445-1-dmatlack@google.com>
 <20261022225035.377445-6-dmatlack@google.com>
Date: Wed, 28 Oct 2026 16:36:59 -0400
Message-Id: <179321981903.1894369.6363169044837754945.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=856;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=9m6WB2manDNmHNkWWaupqwLfpyUxuStC4em+E8XaZ0M=;
 b=kA0DAAoBu3coTNtzet4ByyZiAGriXO2ivBwzasr17tc21/VkmA5BpaNy5weddLAF0Xq+WI3XQ
 IkCMwQAAQoAHRYhBEExqpPstG8a8H82Yrt3KEzbc3reBQJq4lztAAoJELt3KEzbc3rePOYP/2jt
 cPdYHQOGemXNJXRL59xPkeLyW7o1RN8hKWIyLuuP6Ug2pE2KyooLVMtwE8WNXTanREsAnV4iWbp
 18DhLZiTVBE5EkM6/8QNoxAZkBSDn4wK+ams5b+mlNPwywvyaEBEZ5fKKScmaNRUCAewpICwMLl
 6MMU6jooZU3sPMbiNKXJ4N2gI/L88JDIsa8rjkt77+VOWxdfj7cWe04yETLsWkQM10Hks9z7s9X
 ZOWlM1lzsqqXduBkm7t8oYWd3s3WaFw0ZhWD3Jv1SpMGSr1ClSSLecw81Ivne6/TsksTGXzubO7
 calTT+OWXI6Ax7nJh7l9RnbbkISeFgCF1AvY+QBFDjjZWEJTG7Nr0os9xXrFOrGET7jEoXdiT7C
 jarfhSDZOjpTla4/QTgYy5aknwkd6vMf+cTDxSZr0ncV/ztL67ng/SAo+XY2X+LJh8NaLiSyawU
 kESqNdn9F8zlYnkqd76MqKhhnynb2Kl39nk67LtMiZ67kERKg2TIvDyk4/+htE8bVfSCyWrbbza
 9rmcRPjKqVYqc0R782X+ScurAwX9FCOEeZ1pGnyfxpn+KWMPQHz5KhiszhkuX1NuJ3nRTt8rwYp
 TeWhBbAFasJNbFxFUn3xnNwQ/MPrJYtpe1iwAqpgdB5suJ6Wk564LOw8NLWPTuZy1U3/0vj/x6P
 YsuVI
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1EA124000D
X-Stat-Signature: 1n4a1xunkwua8i6666in17bk4r8d839w
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793219825-308604
X-HE-Meta: U2FsdGVkX18SaQEPA9nrhtDvT143/8CVrtIxBDGbElLoOxApJhEGc1QbN+1PxoIcMa6mcAocqlyxSVB+A8CGhDAkpv5DRjGTJd3DsUyJP62hbahSR/2cQYv7wC1VW+IqxkgaB8W35jmlpP6ALsuZqvZI7A7uxtaHWLujQYfNY+SAXTZSSF9AU3+J0M+QbY+9omxJstKYnYaPXxU0vXDxGWJLestqJoF8nYow2uTuQL5G42mPjFeTLVXFf6F2H3lnVDfiFVURvvi8MK0drIJubQ9/ZEeJCOllKijWopJFLHtDFR4t2SgV8EknJxxRussoYC/RK6J6RftruBohLXbFg0UBTMfP9GSTBVr8jeckguQSlKDuuMDVfepp28lGE70jP9YjiZRxRK+hjS75mbHiKzBpBmmBFjd9F+aTA1oP93PbEzUkSFeJvg2Uzy6iblH8HXxImufLmQb+1hvkC4wJY/j8nG7k2HYn60E0hwr/esLEqwaTzQccpmRSrMt9hRayOHCEzoxKqJuhFns0vRx6ysZkliuUgH/vZc4PltAln+Xj9ewThaUmZC0Vrt4wMiIbLCRRs7SKISglydl5EqAimmUWrV/EE2PgShj8NwhxfHF4gEEhxrciwq0qV395YKeyGZmWiv0GxnFRHWU2aUyd8MiYhfAdGFV2cOEkebsL82eVZadmMoTOBgeNCqyfRsoJY8ATFOPSQ7bzoi5rDVgXBa+Lao6yhqM8cb0tbVE8p8Ox/zF9dxcgzKwvMENrzw0nrqNGCtc1tx43yqfnb3OOGlUuADMYGDJKUfkrbL+lMtrB2/2rPzbLC9DSIm4k7TT3qu9j/PD2QNbqw10UkVH1CUg2OUTNd6A3OELBGTdytJabxZ9J43vAZdrdpvGaUHBNYMKQfPYqftyq5TjLKPtpAjoRiKxjTpJGawNRsfF6I1iWw5/hcbb7o0jbmt/J9mG0JvbvOd53qR/vZ+z3yNN
 s5jtjQs5
 DbcNb2fUWyTNFk+CBAKrez7XR4LUQA9Kc6RvX3KAmZhnDi1PeWrwsOZRbIwa59npvrj7EU/ggxYWypfTWiC/99hrAFaR2jFw9YzLMePwlPYn7INIQc3ilmjADR2Mv30v9AZOI709k1+6d1oTOUWO4dJqhR7gFwFZu9VDt/SBVSfIP4qWifmxeXrG2ZWBDFE3V76X4gXYIrujLgAa2VnLR3jgHlETO5pXyZQ5izFRYJJDwNF8GZoAVAUgkQm21xM626BSSMLah0nu9WIk/TSaR5Z4wc1JiC4hUpwzfvpt+2GcvaybIntxeiOnogrwa+7pmX2+fxHsJJxZ1fPIZ3HMB1nDhR861RdAoYEaLt78x3EBenMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 22:50:30 +0000, David Matlack <dmatlack@google.com> wrote:
> Handle a failure to add a retrieved file to luo_preserved_files instead
> of triggering a WARN_ON(). xa_insert() can fail with -ENOMEM, and
> userspace can trigger that with LIVEUPDATE_SESSION_RETRIEVE_FD, so
> warning about it lets userspace crash systems with panic_on_warn.
> 
> The handler has already consumed the preserved state when this happens,
> so make the failure permanent. Keep the file until the file set is
> finished, like any other retrieved file, so that its resources are not
> released before then. Finishing the file set then erases the file from
> luo_preserved_files, which does nothing for a file that was never added.
> 
> [...]

Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

