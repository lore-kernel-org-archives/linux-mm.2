Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 243FFCDB475
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 19:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CDEF6B0005; Mon, 22 Jun 2026 15:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F636B008A; Mon, 22 Jun 2026 15:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495C76B008C; Mon, 22 Jun 2026 15:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5DD56B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:15:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B0D61A02A2
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:15:18 +0000 (UTC)
X-FDA: 84908501916.12.D1CAAC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 70E9518000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:15:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1xmOIEL;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782155716;
	b=EUZID8wyO7BxKU0Ivh68FTgEy2gEd7RpmEkUEoUHM4C/pz+6wteioxoZERPoGD7rQETvWN
	d/ha812MzAPll937Sy48lDsofGbuJEHhsesDBXwivkp7XQ8KQsXeWYpNdGWXFB1JSic45v
	SHpCns9khLnAMpqBiGLqwjo9cKNNm/E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782155716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvX1C/OSlAZ4NbIXg1M5pg/eogym3q/SnHXCNuno5cg=;
	b=VYX+m9hx72BS5/Sm7O5fedl9o5c0yHnuZT9gScPHOTdKJsqoK4zjpPLgeRtAIuaB4IPPXH
	LH/uHfv58V/rfsZnxK0SuJsx05sVTCi3HMzO3CY7ZLPirWkhtZ/N+HUFQOEMojA43aq4gr
	+NK2TmZYB1BXtjIoJCdA1lhEMFnedPY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1xmOIEL;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7EEC601F3;
	Mon, 22 Jun 2026 19:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852091F000E9;
	Mon, 22 Jun 2026 19:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782155715;
	bh=vvX1C/OSlAZ4NbIXg1M5pg/eogym3q/SnHXCNuno5cg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=A1xmOIELCsX8BFlR2se3/5yxn6ahLKhwmMcjPPJtYU5jTsFg6RQRoM7WPHqA0z9qp
	 COtLtQ7QNTGGR/s45seF67ojsLV2su3Dx/8COd4MS2p4hmMbHKadmtJHIH0iL9k7C0
	 inv6vnbHRV0riIHGix/lvawM5A++Pc4JK6RUAr8ePy6SsJN0O8bo9YEUBHrhM1mfRf
	 2e+CqTpy7OLzIkgOkvszQlaODWESvuMJ8hSKTBTKUULvsMVKyYhmprrYQPPmQ7zGvD
	 rdiu94c034Jam9//UUq2qYcw9zFsP7qW1syGpTe/IbhEeQaGB/aDgmMebg0O14q37J
	 2ZGmIRO7PaZ4Q==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RESEND PATCH v3 1/2] kho: add KHOSER_COPY_TYPE(UN)SAFE for
 phys copy
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-mm@kvack.org
In-Reply-To: <20260622111215.4157974-2-tarunsahu@google.com>
References: <20260622111215.4157974-1-tarunsahu@google.com>
 <20260622111215.4157974-2-tarunsahu@google.com>
Date: Mon, 22 Jun 2026 22:15:08 +0300
Message-Id: <178215570871.91679.11260349768439750235.b4-review@b4>
X-Mailer: b4 0.15.2
X-Stat-Signature: 8hkek911dqa3usroya6k163ie3hqs8op
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 70E9518000A
X-HE-Tag: 1782155716-146217
X-HE-Meta: U2FsdGVkX18DCi4UX4pqpXEpumo7qie6NXPEB3+YzkeqUd97h3N4uxWF7O+xp1fsFr2azI8xQH9Y+KuJnKj0ERg1YccK1BaQQEA1nDbKvTz1GjECi/BcbjR4MSDup4gwNwdgJ9BDukMTmvYfoUAxf3yZphNiQr+xr8rWWaww2fH/xdQuxNa0jX1vJIIGEGCoKw4Wbz0WKSbJFtboVnhf/sfGBEpKTwSSpe6/2/PNu7BRMZeK5sMPjGORvL+4hjVhw+GYmGMNNVBNcVIL+m4NxmA/UFU6cVOP0jFLNY6zT5PYP61F7n4YDXaiFol7Y4evnJ3Inu044Ya04b43FVoHsomr9K4IDHDbCJhsw/96mSx6MQuc+irnPe8hvrvWcFdOKIE4qVSqX5yMMvL/jyD15FIV8WIKNdy12w6t13bltLI6IHQdzYXDeZ5lHqhz3RMJbfCIl8WTQtU9a2ae29VXdPVrE2BkdgCvobL15BkyMBigqP1OiGp6RZS7bpj9DvbfAF/GzcScF6/sDIJ+b5HRPXYbOHxCbTa6pc8xMEUkdi/TmKzV7NC7BzVf6mAE3+MjS6AT7GLDNPZyA5aJaarLGSP1m19Hk3auE+/iM0uXLhId+tbjhjRbVb96u7dQhr0XOWPkhNhipNPAAPMfWxfnWtmzvmq1BemzUDKVZOqn8woHT9lfgA/2InhFKtzOAJhzN6gpFUbBP//7usupxevuYoaOVY2zhFLOmg7QQNVtqyjGyrX+TbDxhOF5ZKSaU1tv81SmYJfZbdtL+EmA+yT/Boxq4A0tNDVt6kYxgvB8Mqxp89bNhJv/yHo8lTS82HDAJ0qYFrvr/Hq0TwVUxeFKJi5Wq0YyUDWnNNVVYLmc6Jv/H++6jcAG6nQY7rUGXcDX/kgZSm5QhVCvI9vK5OaFBoeyBBSmMKXe/5TcIOCE0Qpa1SNrC9mXQ3+cBQDNaFVvwlPAA0kP7n5+vv1xiL+
 o4j/z9JU
 GCO/zvbRg5qFFwe0r/XFRr8QmDAWyiic2pKGnq4POZawIJn0qGtMHR1xh0kKvvGNdzM3zdWimK1yMm4uwGr7AiFNoEU/zhhP2SUFlKzbGZmqhPG51d3zl7ZIGQREIS3s/dpoK1J8bYOqHh7ALdQo2lzRkGfgU7mU1E7PZYbYNaaG0c2hLu3YjWMDx9WOdTGy7Wa5niJutqtWZUcQI9N+hxQGyGZXkfSMEka7bs0h7KBb/fMnYQdPg4FJJSDryQNodex7t3JqmIM5S0uKmZ7tovowsYU1d5Q91Ta3O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 11:12:14 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> index 5e2eb8519bda..618408fbe9c9 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -139,6 +139,18 @@
>  		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
>  	})
>  
> +/* Copies one serializable pointer to another of same type. */
> +#define KHOSER_COPY_TYPESAFE(dest, src) \

Maybe name if KHOSER_COPY_PTR?

> +	({ \
> +		typecheck(typeof((dest).ptr), (src).ptr); \

And if we could replace the typecheck with some other magic to allow
void * we won't need the unsafe version.

-- 
Sincerely yours,
Mike.


