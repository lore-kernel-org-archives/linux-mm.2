Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A72FE6FE23
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 18:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905576B0005; Tue, 23 Dec 2025 13:17:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFFB6B0089; Tue, 23 Dec 2025 13:17:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9916B008A; Tue, 23 Dec 2025 13:17:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF166B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 13:17:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20206138556
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 18:17:37 +0000 (UTC)
X-FDA: 84251543754.16.547DC19
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5637C140013
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 18:17:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Mhf7SlQ9;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766513855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2RXmFBnuoUZNP9t3XSeZExCz/tGXq4+QrVc7VKG6+Y=;
	b=niws6EKcXOlf9l6hkIOsmE3QHEpTNT/aL3COdXZXLEIFsrlBQTaybUxlxVQLYaSteXmtKg
	gLysG3N59xNuEK1kAV6EZ5FPePRakXp8xlvw2oKv24lDhusnjlgK5v30Ht43GIgqEhb67f
	x5alTPR/XJlX680Vk0MYZt1swBtXNWc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Mhf7SlQ9;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766513855; a=rsa-sha256;
	cv=none;
	b=087QVENFgoB2uyE92SC3sit8j5umZaaKPfN5U5T502paurke9BdedSKXh46ck16tVWBmYL
	5vNTpdNPYUbyEHfZnBGnVVSB79eHSJlRx+KGe9oPuXNYYmIP7dyCiX9JMt/w2vPamuh2jX
	jxe5r+mAXV6PCv736fX+ysiiKVT0g40=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64b608ffca7so6414845a12.3
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766513854; x=1767118654; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+2RXmFBnuoUZNP9t3XSeZExCz/tGXq4+QrVc7VKG6+Y=;
        b=Mhf7SlQ9d4IZCDK6TxpcI+D4IWhuO0ooQd4uCMbu/2bVNwT/MKx7R9ckQDnrAr4a6Q
         uzkmFJYA8zQR8Ii9MI5zhHDFU14pKjqWDbrAwSZLCXVjB8KCqCFgEJ2G2K12bRWAFJ9n
         VllGhfOc6hY8YoFK/o4EwjOVJOSD6t7ry5MEqVsBb8kaCVEJUXbg3sPo4mEazXJCNSnI
         dvDrADJwEqvquDzd7Gj0rrl9EAx8XtBUF9udvLFE1Hr0AKCkYtbTZrWA5DSMDwZVEGdQ
         788bRA7jse2J8VyVNCVp/Ca3FU2YgufJc49JjWNLkxP4IADSzaQ8BQOXt2tWtTH6eDaH
         fqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766513854; x=1767118654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+2RXmFBnuoUZNP9t3XSeZExCz/tGXq4+QrVc7VKG6+Y=;
        b=IwQ0Jrzq7Gay3USLjyPjZG3sO7cOL7denXszcpq6FoYRqXrNDNZC1L7KDq2GaES6Iw
         ZdbT1ZKar0d1FiXeNBcuZYN82UZa8PGQUDfnM6yZ/UaJnxikA9XjYss/4ndlwRWCU0n0
         +huvythFM+4u3EK6ezJhh5O63RYJHmPgoOoWuGDpkhmyDOfxlM13yyaf888HhdhkOQ9c
         romQoYc5C/iVa7qxT6Us0kNLfY4toe4TGI/MWkqkx/+7CzMG6Lp862fsAaXEED8wXPc0
         IdyHTwfJgaefW2+zb1GHBi7aWNiw7yghzaoUtLavSbzm3Xi5Pr++AF3hgYybH53/A+Qs
         hKQg==
X-Forwarded-Encrypted: i=1; AJvYcCWCcDz6JGe0m5UQL57QICNoYa1KqKntCw5kBfCXBXN6I9BRrMBOQv8ezpRoXX9Dddx7JVcFA6FcTg==@kvack.org
X-Gm-Message-State: AOJu0Yx+jidELPXjXhQ8yUJiZYETNGd6RFw9F49/3mWUX+nVyb2aISjQ
	4v945PqycY2N+PGJ78F8Wldjv2J70B8iRVWSbDwGYziPDxzlSl4SbEZr/XH7uD83HllY8ntAZIf
	0vKDbCq0brCd3T3d6fsmi7GKzyr03BGByFNvEIwKntA==
X-Gm-Gg: AY/fxX7rmQaY40XsNBRyV9zrGLCPBcTvIZdHhU2B2c47biDrpYMsWORd8ZPdbGWz7NT
	ANmAOXa97Z4aOLStxxebkifYM47ABiA1/ZzmjcNqq7c0Eetgo6ZO8YZTn+TvaluTNoibBItf03n
	NStHASqmewAvFwz/1XqkO8R4Pw6qpzBvy62sa6t+r9KEdL9Eru8JWV2zJebC7JpWXWP3XL/jM8n
	nbZ2QXC2H+FU8f1SXMkZgNgkxWOAIOoLAFd0yHtqOOtIfG+pKKOV/q5rJDQdWl2bgxiWZPWbPTb
	NFgG6h01Ci+UjK+lGrYNunJ1kGjQKSh2nCKa
X-Google-Smtp-Source: AGHT+IG7R8OufzxbkFMNpnBpqEEtRO/h0PChaYqg3fbSuA3NHtdOdOdeSWlvgqHDikQUpiHUXPkzTwN9tQJ5alYq+AI=
X-Received: by 2002:a05:6402:5112:b0:64b:ea6b:a884 with SMTP id
 4fb4d7f45d1cf-64bea6baac4mr14256712a12.17.1766513853843; Tue, 23 Dec 2025
 10:17:33 -0800 (PST)
MIME-Version: 1.0
References: <20251206230222.853493-1-pratyush@kernel.org> <20251206230222.853493-9-pratyush@kernel.org>
In-Reply-To: <20251206230222.853493-9-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 23 Dec 2025 13:16:57 -0500
X-Gm-Features: AQt7F2o9lKh-MiYjTN0jydTh4lXfEZrS5Ed5W1ywUvAOmrIraj_P1WZBiW42-WU
Message-ID: <CA+CK2bBeJwACBiKsuXLcbzC4m0zLhu0yNg2HDGR=AQGeEVCJjg@mail.gmail.com>
Subject: Re: [RFC PATCH 08/10] mm: hugetlb: disable CMA if liveupdate is enabled
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: k34bb18kwiw7a5ojhjrg6i8ycmuqpdio
X-Rspam-User: 
X-Rspamd-Queue-Id: 5637C140013
X-HE-Tag: 1766513855-655997
X-HE-Meta: U2FsdGVkX19HOL7bj9wZvDe37tJvIQOsOzRjlbLFxpiowFUMqrDwlw7qxUS8+mruhFP6qnqSexnJdJjtXzzaqq7vneBAB8zRRYkY8xrlTd9XFb+Buz9ZpDVly+kasaBxe6FxxzHEZ4oeD/afttYOVpyFBuD9I9w4TvbBMnx52Kocb+GK1zpc5nVz3CJuoGSOLNg5HYkNccjrEFRRjaFtB71wmMoh5cctOWqt+sHYpTtaZhxGWM6Zv5Wy3o7WFJXRm/2Nxj2/nKBkAKmoqzBUhrY9pNPegsuUVt5oxvuN4+JiC9RfF+cQSMgOGnImcvy6iRo59y3WHtOcpIJYS7Js1kWBbEWrJUx7mN4uz3Y6k88uFS5H30j5TCp4ICCWJvN14s1LS4WQ1lkqOqKycR/e2rQqdCfygzhKISoordTBuJxfUKvOq24PwMEO5NE/0cYmmlIgtUMEvn0ynv+uhfhGDEp75qlrgesFmvmLaPQepXDM/S5FTIhhxlykTiZ2auMDjz+5uT0GDdQoCdZQ7zZrNYtrca77y5x0dcyURhuYZd9x6wJnAwFA3A/fnt7/kUL6tiELmI4mOni53nWcp9ekRhLA/VtfCIzlJh2r9uMP16SGtSOsIEoCPEsjQeq8+BLEKyLd13VvnCa1/eLBLKcRpAbdagSkbhw3lAhLrYUp+ouucvY2ajiFzkVnFt/ChpkKtDxNwetF14p10pErid2OytT6JCL8zjTqxwNvinzHIrAgxHsZUkeiXFxJgnoRxR/CQ3gBj0e9np2YglIKnaKZUvsauFry44EX+f8QLnn59ppygC1L5n0G/h3hg9oKQljQncgQ/++yifFca9oP/h4CVQy9yD6h4b5QiUVIH92pxDoz3n2uLgBvuK451nrCZPcOKzxTuTCq1IA602D3NpExG0FYSXXX/b1S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 6, 2025 at 6:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> Hugetlb live update support does not yet work with CMA. Print a warning
> and disable CMA if the config for live updating hugetlb is enabled, and
> liveupdate is enabled at runtime.

Could you please elaborate this commit to explain why it is not
supported, and what it would take to support CMA.

Thanks,
Pasha

