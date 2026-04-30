Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D642FCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 19:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2522B6B0088; Thu, 30 Apr 2026 15:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202CB6B008A; Thu, 30 Apr 2026 15:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1656B008C; Thu, 30 Apr 2026 15:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE7266B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:12:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CB421A01BF
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:12:30 +0000 (UTC)
X-FDA: 84716168460.19.6D70BDA
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 36EF140002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:12:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="nxx/9k18";
	spf=pass (imf17.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777576348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8xqxPiz+Lc8RbIzGx9Onv6CwKKtwUHfXe/yYDo0xXQ=;
	b=7MLFg2+GjOxlP6LEcNp8acrf4QoRIao6IsvhieeQ6tyQdb95AYeD/aPYHUQK3Lx6FmxpLX
	FJ3Ib+WVp0pWWeBF3bVsuA1aJUZDSCG4G0pqTMmqJEJHJLxEZ3vrrG7vN0iYAYhTTTaZRB
	rtD9e5rn9aPCt0H9KfKhRMQ/E7fXMbM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="nxx/9k18";
	spf=pass (imf17.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777576348; a=rsa-sha256;
	cv=pass;
	b=XITwa8gNqLoPs4O1f/C0Dr6gCyoqkY2jS1KEJlWxqxBo1yhrN4+3wKh6krGg1081+vjdb3
	7FJHvF0Pq3lpILJu86dqLod7Y16+1IstHveKr1OZ9MDa8u9sdbQz2QkgBIRFAH8JojPN4J
	N7i1lWizRoN7E02AXJPBked62exeoJA=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso2096a12.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:12:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777576346; cv=none;
        d=google.com; s=arc-20240605;
        b=GfCjcTjBmgVU/ZaDyrF6KBDoQZoViNuYXKYNx90mLDtXxPrlVGyt7oCEvlNMnabh5z
         JtVGhJli5gp1XpGmROmN0QuNpxo04DcFBZkeT+bU9ffG1oGRLl31XeNvdfBvjJNq2fkf
         nq/2Z5Zy7xdOwQr4QzqCV/nnK8EvKHF9fm0tvcPpgjeiu8s5Ju1S2CCo0SbDEomziCy0
         j5qpkUnLl2ceGeOJA5YJP3sj5rV7eJqEmH9BWerxI6p0rTyIZJMgJvdRhic/ajh7r+d2
         s1QmvEGm5hrKIocKSDCgUpsPjMZYlcYydyaT/LHEFILdmJkPyNI22sYJDaIqdHglAsVM
         l6Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N8xqxPiz+Lc8RbIzGx9Onv6CwKKtwUHfXe/yYDo0xXQ=;
        fh=tOu9uOR450tMKKDJ9GByFvDuvpx2YJfIPEOej6AJKAs=;
        b=NR8EnwDBn113KG2R61BKcEXOZ+yL4fTjT66iRY5XrZwI39jTcz6GmMQwyDlHVa2EHk
         L1cnMOVtDWzsXXjgwjo+2jGW6kT3344UL62NXsez3suxw134WOoz1SFDRef/l6UTU1Dm
         L+c+gUEDo6ri7/0uTU0DnuRyYqCb2vh4OYYtw72Ug4RybZrGslYdaaY7Zp9s3hjjFLl9
         twQesgedZFXHuqbqfzVqRgZYO+/JBoK1Di4TP2l12PSybUUdDPwjOJsbUtk94k/oLFr7
         xMREqmi3xvM8M5jVVDDzS719eDN/Buln3t/MMh5vmwMtSo142g65PRRVAeRf1bQsRDHn
         ZQTA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777576346; x=1778181146; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8xqxPiz+Lc8RbIzGx9Onv6CwKKtwUHfXe/yYDo0xXQ=;
        b=nxx/9k18FJ6W/WEmOeC5WjgINuAZOySMete/z9N+yVvH5O9/8TytVHkwyAYzo7R0ba
         xbfak/7M1Zz5JVzWc8hM+KcW55O3z+nrKvnQ3JxnRiBjtB4Zh6HzLgpZwxLZGiteF0lI
         wGM3k89mo3VnImz4Jox7ZAZ8DUCtT9OWI3XT14iqJ4wWcj47eaIeVzJu1lthZ7WRjG8c
         uwrDTtKqxlKGFqA20XLBIQEJ61k9JUs0VJc5SOE+K7Akcz8aYsbm83tZpYxIoQNLznyT
         SA5e8wa0L1UbRqc0D5ADKozctH9FQT+VLlNqLkCol+X+F7asSCrbMgD70Dhb26ngcDgs
         DI2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777576346; x=1778181146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N8xqxPiz+Lc8RbIzGx9Onv6CwKKtwUHfXe/yYDo0xXQ=;
        b=pwYCHS90zaBmX3KTPyuo1+Fk+RqzAIGekj3AoSLd9jgB7MF6IE25AoSEkIq1LfmvPy
         PQDebLab7E/Gu68y6qppGSejGOqPfqKfy1oBXW+uFbJUjlqOktQNc75bVpy+iYVt/gba
         WDL7j/UlDUeuqSZWQr1n3BNxUx2I/1985anuCQ1rOlQ6/DV9wFveOh6bzfECCGwMOFOX
         sKhrrOESoStSgpqdRckun04caDFUAlRCPmGup0xoEvnXIJKmeTvLOYEVYeetuvS5AYyC
         bSXkvgVLbCt8wNt8emcRmQhZ5BFaDtX2RiK27RaK5x6+lhsPh53zz7evU5u8rD2IYPjo
         AleQ==
X-Forwarded-Encrypted: i=1; AFNElJ/eV++IYhc0BkowXFYMQanXZviMBHXi0W7vigcDcbOic8JVwq2vJyPZ8pOHmRjIRY5P5/NjGygncw==@kvack.org
X-Gm-Message-State: AOJu0YxjPm0pMFx1JHSIF2dKXZlNqq71CDITAkqdj+AZ6raax3hTazIM
	a3/aldNf58mJrXvO+9D1skR8TXT4+H6VHeK4lmlLU63N/ToNMIGMygzl7+VkZsiFdsBJ+c2Cgs7
	rK8RXdjUxYqU/8QJZE67n1EiCGNLKEBibJaMdnBCI
X-Gm-Gg: AeBDietIgMmEIz26qoe0nFHLDkntyzRuaUOy5yCmUMUtlhmB44AfSsTyyncGpwO64xe
	1104jwih/svwM/tm+CihowfxucLw6t3livdT/K14ixbmIh+R4jUuF3YspUD5IlHZbKuZB9fBeyi
	xoRMkF1iZtFTSeqt++G2453yXJaNoZpPw4L13Kd+0GvDicr0TI/NfLjxd8AHrii4Q9qVzZMBEBT
	BytlfSpQqeYcVkbSUBJiK0E5+vNZTNIsdYx44hTXUFkVy9PXLqRG9+63rNCzdTjzGsu9qPpeEGZ
	8hmoQOb8w1b8TKsrlVZEbYeA7J2N9QQlPD4+qvbxorLKcGeaUf33fRPEsg==
X-Received: by 2002:aa7:c499:0:b0:678:8834:1b49 with SMTP id
 4fb4d7f45d1cf-67b92d3d685mr6855a12.1.1777576346007; Thu, 30 Apr 2026 12:12:26
 -0700 (PDT)
MIME-Version: 1.0
References: <20260429131522.4049054-1-dtominac@cisco.com> <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
 <afIiqR5CqYRId0N0@redhat.com> <afJz3l6435DHLorn@goliath> <afMeAs6upm8kLCYb@redhat.com>
 <2d815203-a81e-40b4-92ba-31832c84c20b@kernel.org> <afOjk9igx9nlc9cg@redhat.com>
In-Reply-To: <afOjk9igx9nlc9cg@redhat.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 30 Apr 2026 21:11:49 +0200
X-Gm-Features: AVHnY4K-YxCsSWEfMM3euP0MFRxkho2vVQKGYi2YKLesi4gZWVCDrwbxNVlDvgE
Message-ID: <CAG48ez1B7ubv6yJWA4CoSm3AzzyiNHzcAz0ByX_VhCqaA+iQTw@mail.gmail.com>
Subject: Re: [PATCH] mm/madvise: preserve uprobe breakpoints across MADV_DONTNEED
To: Oleg Nesterov <oleg@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Daniel Walker (danielwa)" <danielwa@cisco.com>, 
	"Darko Tominac -X (dtominac - GLOBALLOGIC INC at Cisco)" <dtominac@cisco.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, 
	"xe-linux-external(mailer list)" <xe-linux-external@cisco.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, 
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 36EF140002
X-Stat-Signature: j1yuptdtz39ndarm9dyzc6ky8ma914zi
X-HE-Tag: 1777576347-646464
X-HE-Meta: U2FsdGVkX18twkCNUcMNO1xJgwBINTvnYtkEhxE61EXyYwfsOk+flyHX7+joPLjBtSWjI/aYH9Zt383Ke3pJWMOZX4+mymKljHeJsNeKcCHIGgnbzQ2fcclQ9JzorHPEMZ3vr08qznxZQNRzg+v4PsSlR7ybafKb14LRpkYkJ8lAJlUeamt8uH8wSHV8253H+tejw1dDrDVedSa6xi/SUKXSz8RZT04Y1T7PkV0M0iUl2MFP5ymrfqlg/twLmvtREgnwikQ+nGJro0DxDRai/gFTYjz4ReCBT4PqEq7lV9q+uj/WxuOYXhJdf+aS4mT/VBQZ14owygbcZ1ZG/al49EU4a6wW7lH2yvNsdoDpK7XHYt/lOFj+LpmAag9Vn1alSAIZYsEqmkLZfRgp2hBdVoVtQRkmlqvLArU6dUsFFCWtx6lt2CwokSB8ObYYplW2uPMN9foIj8qIYxLjNUt8zLQRZoja68x9+fpPIxjGQ8rwt1P5s2sBs171+jsJ4EzOiTQZ4apo2vcLmrArBKleGQKCTJl43xkyeS5cJLJglInZkdn8AVUpzx79nwcOHskba8Uqz78fGjxvCHBQeOCz5zkOPzuCGs9LXI4LaxLVpOnvnBhtUzB7qLKU4NX9WmqC6PWiin6+higThUKUs+LQz8wkAZHtA5SyGh5luJS8Q0ooJgiVDIpkHjiJwPt31u54Of5HgiPKcz9vn83yCoNDaozaj5eioAMdskhvfpSqSmd14nM/8u2IEn9gpgWCeAySK1jgGgDcBGMJEY7KeHBTQJvpjRwmPKHOHgALrHjnce5TdoXUKz46Yb/WTh+YV37wwH+9ylAv1IbP/KcSg8CIkSuY1bBSeqF6Of5FTIxBe8fPLcbMop048mrgFJ+DsZHlm0IjcxZNS1rpqH5ADzTzN5T6odYSeHyfQ+40CDtbv1g74DbKS8oHssZhl8xXQd31tH2o9530hvfnq2DKa9y
 hOUVG6H/
 Ydg+5iFpD+bOTfC41sX1L4p+H9NG9+clbA52hsi0h7a8PoQHCy+b5X+gdnZpsB+6PC6o101oQ51OqyQDyV5j0X126ey2DDW36rrhf62DJ3MC7oVxCcn5dml5Ue48JGjmTg8pGsu93mwNVo6HYelXq9s0hctxOenxBNOc5FWL1CIvAX+9ODBfjZ/4U2SlpTLKYuIiVkmbKMPxOWzi4u+jZvWH0UXiHobZ/n+csMKpPfz6xXvukhhUyuXGu/4riqdyj/idf+h5WZEtfHw6xWyFtgzw+6xwqaEBGKu6D4kfBkFbMysRJu2sdIqsy/AEZPEbD7NARzNdZDben0rtxdW6HKW73ScuniD1i+JsO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 8:47=E2=80=AFPM Oleg Nesterov <oleg@redhat.com> wro=
te:
> _In that case_. Instead of this patch (which, rightly or not, I personall=
y dislike
> in any case), can't MADV_DONTNEED paths check MMF_HAS_UPROBES or vma_has_=
uprobes()
> to decide whether .even_cows should be true?

The manpage currently essentially guarantees that MADV_DONTNEED
discards CoW pages. I think it would be a bad idea to change that
documented behavior without a strong reason, especially if that means
we'd have to add more special cases to the UAPI contract.

