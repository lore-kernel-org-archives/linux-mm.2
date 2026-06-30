Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DFB9C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 05:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023666B00A8; Tue, 30 Jun 2026 01:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16656B00AC; Tue, 30 Jun 2026 01:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07316B00AD; Tue, 30 Jun 2026 01:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BABE36B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:19:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15CFE140376
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:19:06 +0000 (UTC)
X-FDA: 84935425092.26.49198B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4422F1C0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:19:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UgsFi+y0;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782796744;
	b=5OuvM2XYWIomvHooadTMcAUATCj6RYTr/mhnxMKlFCTiZH/6ajzQU95bnG5Pr7rj6f6wk9
	0cl5L75tD0FkAzraxf/x5VRL+1fqBPAIb55l8KdKvDS9TpwPnMQbsytflI76TKp0Dyb5Or
	7CA18Q+piUa+WN6XUfZrkOEBoXlvEgY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782796744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrONtPVV7zUCula2/YAHjJXiKOtVpzbmkuviUSsjv3Q=;
	b=UI309VmnxMXuR1CZ8X5ixnQrsKENfpvV2lfJxwQkXLX0bDeEEnLKP5j7tLa4UbjwtRpYEM
	0KEjNufioFssddfWDmyvmsJpw1MAy/Tz2Nr+t/aDhwvaGk6DA31tWud/fE/8i8JGCXvVKr
	XtFAkugZUVkpvXcyLrGlsJby+B7+jtk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UgsFi+y0;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 466C642B26;
	Tue, 30 Jun 2026 05:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BF61F000E9;
	Tue, 30 Jun 2026 05:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782796743;
	bh=VrONtPVV7zUCula2/YAHjJXiKOtVpzbmkuviUSsjv3Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UgsFi+y0UrCMsD/dl3fNCkuiCapjOvPAyXn6lZoMmcJNxVzU0c29Qawv53Xkp1Ump
	 nCo/3G83tjQRRXa6gaTUg6ic2gssezYNdp53m4e+zp27cxQMvCfbvskPs2TlF//Jiu
	 wzcFI+sPf92PhMp0u3jC26CNiIdUKrjPc4znrtN+6zlBJArV/SJ+tJqbShk1p0bQ7c
	 8nIStgaY290Jy5KXR4OEFW+u9VijZ2PtxlvecnUzqlWlFHeWNLxwn5Fc4k8tiHD28J
	 eyxPxOPcXsj2sMhJnnSJFS5Av0LPRtlTJgcedk5Jcg/KUmMot9QC2DxOLNRkLbFicq
	 ybFaIKWezuyxg==
Message-ID: <d9c198e9-498b-4f4c-966a-17fa39427f21@kernel.org>
Date: Tue, 30 Jun 2026 07:18:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] MAINTAINERS: s/SeongJae/SJ/
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260630013820.143366-1-sj@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630013820.143366-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8cbep897d6byzrbnu76xszn6z8g14bun
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4422F1C0009
X-HE-Tag: 1782796744-564022
X-HE-Meta: U2FsdGVkX18D1hfopiYgVDbRrS0miVZpZSyXrgNP0e0gFdiRV0hvJl+ujFwySxsTjK5JcsUa2whpqOwJTvyHnq/0Emz0pnXSAIjzD5uosSwcflWlsIz6g8c0q3UpjIFsjlb8gwIY1N4vfYRnL4E7erY8Kgp8eI1KmTh7jiBIrpmuQTxSY9fbawdS/ATJMK30AoJdvAzmYtA94rJrypLUcfOgfoObpnQaHJeFs0IhL3oj2lMToGGDbPVbUGxx18knm5fa7PwqHwYkp2qwtF6/Q5UffjJayJ85/zDh6ypX7qFRocmKjj0n5aEbkyGZJaKsWjOJbPNFdIoADClkhfstguZLyH/ti1IpQMV2kBMAjiQVSNNB7/eqQ5Ty+dmGH/jkuo0BY7TOL5m3F6BkhJUdjPrwnUjbdXuKO0FJYITpZ+56s0P9f0d0MRo9HS7Wb1KLDYpFWFNG3mVNSSKI4qh8Oq7SVrntOexbPpcDsOKWyD54nNHAUNKB2q3H9+EaBlAY7aFywGTcNRBSIgkp2+bvqs+OxXujDrjWK/VLkxQ/LsHU5uVmRB9IMdkNpGsafpv96MmqIZRiKXOwv5fcGtvbvd654ri4x+SYThv3TzQWrv3EVdEC94Rj0HOr18mVufJLfFlTI5Gzd3xm07uiEJ5qqFc6ysy7U+jOlhokJgWLbsSk/3xx/ygLaFElDbYdXTnyIoOGL7jETLEMp6gt6A+pXSMiXlVBeRZeSV7+zNA4UOUS1kVEnQv/r3xfb+kNnnCkVgZriGqBs+DubV2rVIzm8Bp4h2yKLQgEtz+EVe8yZKMOop9WjBINd4kY0dv+q+wp4N9VGZ0BzFcgev3lBnuQaNOv9vu+7UTb+Faymn9Jf1T/HZRWBhSvkOd44PDzbNNSjeGcoTg9ufsBALWrUlp9yUN0yX15FltAeu07lhG5euoP9J7bc9nXoKm91GJaaJTlP37/ZQwhRdc+usYgWXn
 ECDvMTEO
 L4lIAktKkokuFG53CRJLZ+ht9h5ljIvNfatll5mo53YFByt4+S25C3mRLmUDJu+HIgzZUg8Z0WppAjkWXCJ7OHR4JbxmkHXyrcmCcbE4xc+//su8rBfi3Ez5u3l0o8XEg0wH6BPbO7xacA4zqXKZIS4COBR4LrfVzkWNi+07NgwVcBCHgk9XHQmKT9C2TuIxHWhaiJUJ3ZktoooixfOjZYaKM0rLan4GnjJRcJZkSGXgWwNPINKHSzgmlJ8XzE5kZnD52M/fIP2NiRKJZwyRjfGpqbUFpC6nC4nhK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 03:38, SJ Park wrote:
> My legal and preferred first names are SeongJae and SJ, respectively.  I
> was using the legal name for commits and tags, while using the preferred
> name for conversations.  It sometimes confuses people including myself.
> Consistently use the preferred name.
> 
> Together remove copyright notes on files.  Those are only confusing for
> people who are not familiar with the law.  Meanwhile, we can infer the
> information in a better way from git logs and public information.
> 
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

