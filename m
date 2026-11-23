Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5C5606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=UhPyC9FX
Received: by kanga.kvack.org (Postfix)
	id BA2766B05B4; Mon, 23 Nov 2026 08:40:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13F86B05B5; Mon, 23 Nov 2026 08:40:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B52E6B05B6; Mon, 23 Nov 2026 08:40:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67B6D6B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:40:42 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB6B41A0893
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:40:41 +0000 (UTC)
X-FDA: 85466493882.16.D66987E
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 97B9340006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:40:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=UhPyC9FX;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795441240;
	b=LKyC5Gqfl6RL2klKMpcwqKJT9EtF5mtijmOj0jsYYdlfdkXs3yF9unDTEX37Kahp55w2uV
	YQzyqkYhL0MBzVg1cU8kBzlFVxKa8f3v0ZuL6cE9WG6sUO3Zl+dDBNcLwoZ3xNiviUDRuO
	v3pUrYCzAlQmsnRneE4IVbu6/vAqK/E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8GkoF4Y0/ft7koVRoDNSDYckCyyov087UPkNw1u++8=;
	b=IkhM8TdlxW19dU37ZKTmZnCqNxFJXov/x4sSMIZptl0t3P0n/Udv86AN+55uV/SLD++1my
	hbntRgyUO08VGccLqyM/8+lrh4kvfxxr7n9odvoNdecUiiasYGpQpgP4eQamtYlYcbp2xx
	ypGZn/v+lADHh0WColu6taD0yuvixHw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=UhPyC9FX;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c5133831027so470194066b.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:40:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795441238; cv=none;
        d=google.com; s=arc-20260327;
        b=Ks+kIXa6get6X8WTRDbgelXOLROBYXsPUAoIbrEuVDsyd5QmDjN6NYZn/8Ep8zXagD
         iz0FBH/st9A24oTAXKRrMfOEs7fqsscFbAF26U7ugTYehIZ+CqYVcXEqF3Mg5svdsQ1/
         VuM5dVVJ7JAX0qPq9UJjNRpPeQH1puGHfVr+0y4AAP00tCLpwjYQR7Imkg7yUiV+o2Og
         M9AaAYJZVbAl+IeeuALL7FuppcuELkJ2MEZ1MYqcw4JUSQP72+TG9tFi+QQoGr/llPaa
         NLFW9bDWaI9PNEG+cH7Y+PXdmPQMw9Zc+so9Hkx+mW9m9AjsyjgirT35EDwevOGAGZ+D
         5TWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s8GkoF4Y0/ft7koVRoDNSDYckCyyov087UPkNw1u++8=;
        fh=wh3UzyFGutpOy4DkgYJZHuOlCe2SRHTjVs917XsZCm4=;
        b=YnukRbeqAagDg1266ydFuaj+dX3naUKBuqheP+KQSSZAKMFhvXs1CkazFzgIN43gS7
         DuCDSBb9FusOad/KQ/UNV8DIICDaFOFZzXOzECRGxoKdMQboX3W0h/HZbuIhHXF5SDru
         T+F9FRX7/+pNcoeWfDLCAd4nd0o3HqsirtVXUne+irBgUoRQ+WgETmwBJhwxIHwd9ItD
         klvOv6vP9JsJMXneJdc0wse9lzcTMXmr6/KyxSMHNo87EF/HVL+a42xub8YjBMSQVzhX
         L9618omZDsLs0Wnr/urckNrfIKRL6ga+zPhYgSfZEW6EnKzeF7aoJWcAzrCWgoluzHW4
         cabw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795441238; x=1796046038; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s8GkoF4Y0/ft7koVRoDNSDYckCyyov087UPkNw1u++8=;
        b=UhPyC9FXqiFQgX724iH0898gMJQhOs1Ust+0dzo2lwhFuVZVV1EJEkn4ADyu+KZmgY
         1jDaX7LQVvo0EpOx+vP+3WymYKCWqWfrKr7EkS1bWDOF6SSJ0rmAZ/HIJKx0+RTZytpI
         t6HpTfNsAj6BVltGWFDTADn+cxOi/FvM3eY0DH4ggN0OsvMnblxi8KPlNm4bTZKPgaWT
         fMD3fDn4KLvcEdAhrV+HkgOJWiZ99LcnX0sphMbVKvBzftoVCnsuFGsOpXFryZbN+4Au
         li262YqhDh8KyhQdLHm67WvWWRorT6xWT39xbONchmWjSsZ+mwrm6xZ/ycxtTwEx6++j
         8ghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795441238; x=1796046038;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s8GkoF4Y0/ft7koVRoDNSDYckCyyov087UPkNw1u++8=;
        b=jILClq+NJy831ybxKdmRgFK/urVQndrcRkLnG5XAH9jZP8SerVbSdwiyeAMn4BpWSv
         YRdhRSNRbd0YAtNc7IkmgD+sWwnn5bouJcQ5cg9hJ1llth/+iKEek2r6z78dwHFvYCte
         mg15ZvrQmNKNCO9/rQ2usRKeqkT1k2G8XqYFfldjAtgB3+mlrCnZL0O8jntAfSFjz8P/
         /Pr8nnov0rMh06zuLkzYhpLOClb1cEgsjh8fFd9HYNM+VQllJWBxWWLiyIHok/fGsdiF
         0ibToF6dEyyQeBXuuY0VUrE5/elBsCkps7QwL4dsGQuclLLJv0nhSgR9nkpc2y/ag9Q6
         j+0w==
X-Forwarded-Encrypted: i=1; AL+hErHGt1IFx7BcgmTew/YnVJbsvE+jZOvrpHiosXyJrRY/PlKYsIsWrdSt/P2el3ksTKxrKIql9FRcEg==@kvack.org
X-Gm-Message-State: APuU4Z/cW+g6If1YjbQM4wrWo5nb0/Hy7aNbNV3o1fQneDFy7bG9LZnQ
	WCg5rTGROXkXCj0mtH0xtuoS/7j4jhoEAkADfK09X+qfYhKEOgiHfz//BH2E62E8NcelYBNtUkC
	K8DDq96NBvPgxwAj5XUqf59SJddObuqqtM5dsaUUOBQ==
X-Gm-Gg: AZFdTZdCE3dbQSTQuRN+luEFj3qczkq/Ovlu+Yq2VKpQc3lgahuiZ4WJN9cEuGtda01
	SDBKp/50O4eR5OvDYZvl+TyxAoEJCEeva+flfTheqrvzgNf5nTXGACgn+zcPQWA+6cQOydkyLE2
	SfUXcTnfaiNFgUeFg2AonIom5ixHqjBeGkjdgCeexktoHWMaKmTGDDsLpQexm0ufseYQYJZHBZ4
	MseYQl4nGL/Y8Kqzhyj9q4kGjFNkgwa17AvNszmQp+f+X14wt73RjwC/Wrgqp2gpBGyUP4tCY6Z
	cCEOHyluMehAOD260xzGiwHq60djSBU2s3trkg+gNGySqQGDRC6LfwjRcISgFrN9lwnZcDw85m7
	UFePGps3Dov3k/lzGaskzWQnLsuQwfH0903ZqcG/mJzhdNyPO94H3mko9NtBggHdmkw==
X-Received: by 2002:a17:906:26cd:b0:c41:26b8:c49c with SMTP id
 a640c23a62f3a-c513a5db1d6mr705781866b.10.1795441238134; Mon, 23 Nov 2026
 05:40:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116081403.216452-1-max.kellermann@ionos.com>
 <20261116081403.216452-4-max.kellermann@ionos.com> <CAGsJ_4yZznwxOZmfeB2SpgT1enRbQMyKnN4QjEFdoN-PJi7mkg@mail.gmail.com>
In-Reply-To: <CAGsJ_4yZznwxOZmfeB2SpgT1enRbQMyKnN4QjEFdoN-PJi7mkg@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 23 Nov 2026 14:40:26 +0100
X-Gm-Features: Aa3M54rKU_f5FEXDCm7DW4j2_TEpJvEJvFs2TZ2jyZi7ub4II_dViU-T8MrTO6c
Message-ID: <CAKPOu+_SL_XBzgREAgptx8mVouOBg9xVj7q-DW0cyNHay8oHjg@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5unwmn6enyg4mwzyfkz361hfefktsqir
X-Rspam-User:
X-Rspamd-Queue-Id: 97B9340006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795441239-642321
X-HE-Meta: U2FsdGVkX1/B7Eh7u/nRnKDVSZif0H1D4Mukj9nrD3c1FNKBH/eiEKGGpGHGORrvnqvLf4ePbDd/2NlIHDAjX+N/IcVVS+Hb7Q6IB0QqsF9eGA1gou7ZVTillv/AIlwpsHDZC29FiJPs2QN6hYoE27aFaCzVSgk4qbiz0bpJjIph6zE+EcoHfIAkkTXlc04oaxuaQbK3+S7JnUAPA6wjyaAUBuSoNUVVMck4+AzPSMeFyXKdNDlK953l0je0lM/hK4b52podvhX2rcaJDWNwGxqTz3tgjuIz+7dfIM23RUgR9LoC/vShl3RvVFY86g28RP7Ov/gPa7Q59ySgd+TPDQzDe2WyGKY8tbXqAVg8/tnbxIEzWbh26+Qx32qwHN/UevNiOc0Gck4wU1ixU/EYAGTsSHechTX4BZ8LfvFW7EZIT4hbFpsoQy+dkna2zQ2hFmqDaRu5Wz560u0wHJMpYcDkXvHjrsiI3CNXipvkYVMPhK1gSZC/jidrQY5hxEBIr+EAs9elhDRmcU4OK5+k159wuX07iteVnbBervj0Qk0ScHxd+VHO+aVDnt/olKlicTYlPrdRIi9vxWLFlYMvSs9DC8iuakHvdBe0DVjeRkrCX2ZnEQU+RwA0h6Qc4IcR+w7tAj7tl7Chg8l7vmq0M1IvYrV5q0Ha2Zd+mkNCZqJAQgJnIRjfhzqNRgX3WtTPKceyDiIR2kJsKm/jJ7rbV8vz5KQ8CwcVLj4JzfffRQuYVME7R0fEWiluS9gvTfTyERU6VrXCbE8t2l4U95q+WDGLAt3VXVLAO/dR0gDvfBBndk+tAZObXHHnBNjuSac5AcDx8L06QhUbHqYTfOscte+Jg+9ABuR3107DvMKe0c7x2v97OFjDcrg8qDNw7hmdeBnBZmMSU/2TICU4kxAAKPo5deQgB1WygykZRBlwG15rbjwXN1rhNi++TTtXDqNfytBdpWofFclcjggITgj
 vb2GdB6f
 0Lu4ejlNTCYOyPbGQQ3CTNzLT7/Vev0KIOxYKsujqvnS6Bo6NxEeytm7t8VWEgBkJVfgwU0cJJ1YmxLaAaY1uGu1z6x+ZQg/Jsy8C0ia1CufhnKDT8C6s83A1UkH3ImwxY+8JkgG2SD7Klb/SE6YxHkJjTn8B7qjM4KcSYMRa1DplfCjxSDUpjUEiZGZ/DuNgi+9FtQGEeqTsljY5Y078kI6qZ/AcIX2ay9YFPxkEOHGvZbcWXveUMvRyTgU51lW6dYHpJypTjVz1gmucB39GNMagfnfTPD8MQqnj88laLbi4IOostjGChdpB6M1D4nsoqvCW/rm0vXI34DWM+87flVC8dBYY79M2eHfvQv7htKiYe+vfN+aGGxGnQExRIdm1ZtMEawUsRe65oq3X1xk9O27JjEIkH5NPa8fAYBQBs0W1OVo1P7kmvI35ctaN8rPHQ2s+CIiP9h+oMEBhPJBAdYlfpNA8KZVf2LPCQEzbAtvl4eGIb3DT0cpbJKTIhhOIOKbzxcRHpOW9GHkkwqa89JQ8egyye1aWRpgU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 2:53=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
> So this is the case where the list is empty, right? Maybe add a
> WARN_ON_ONCE() check before this code to make the assumption explicit
> and catch potential violations in the future.
>
> VM_WARN_ON_ONCE(!last !=3D hlist_nulls_empty(head));

Added, and I'll send v4 today.

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

