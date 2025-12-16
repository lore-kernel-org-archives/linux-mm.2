Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13347D5B87A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 00:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760426B0088; Mon, 15 Dec 2025 19:15:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733576B0089; Mon, 15 Dec 2025 19:15:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629DE6B008A; Mon, 15 Dec 2025 19:15:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49F006B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:15:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E53BE601BB
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:15:22 +0000 (UTC)
X-FDA: 84223414884.15.12BE05B
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id D696F4000F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:15:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4HMwtqyy;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765844120; a=rsa-sha256;
	cv=pass;
	b=RLcnZcMd3bIdQ3GTb38bf2G2T6eA0ki5EpXBhnQz6TUxIS++RA1QGs4ok9hYdJeP1/X2EX
	4TII+tfNzF0ibf2rMw6y2A7u3rgT7c5J+LtlHXrSe6y/OjjJ/3LrI+0M8OiZBHgfBZHG8F
	j989kJTkuHJyJVYgIozMbsYG1ngAD4I=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4HMwtqyy;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765844120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fn0GwhoNH8+ZzMJCJ3+pwW254YPaPG3Wl453zVROsYE=;
	b=ibNaEl4GwzQiISX5Zza7EACxUBZUmF7L8dyjOdzyaPHvLaIVDKIbEFMK1tZN7Eut0B/FTE
	xsUmbi7W6+8nFcLQYnJ8Gpxg5aX5H07COYkJ4Gda5XKw1DikHW9c1q0ffpnqmW5x5ko6fj
	H3HHSSSq8DGTUrqSEU74g86a3A1EA7s=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29f02651fccso39895ad.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:15:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765844120; cv=none;
        d=google.com; s=arc-20240605;
        b=Mlxz3IrVNNDLIjKuXehfNavcIZJ5N6yS/BjIWY8N1whyGBXXhL92wuWxLZOfMojWL0
         xm9NzxO4VT0CVd6pQha7dWFfYnaMVL7/Lwxa1pYK6+IbZsBeNZKLnM5webDaijent2SH
         lEQMgrQQshe7Ij2YnuYABWiRHAc7cZd4GmmgMzx390yDhZpEEOPtrvwjsKrPHZi/CgrM
         yTpRp+J58Fes9tcQKABBFpf/IirLXsQehT8uP8ix32PAhVgoflWe1FO8sgUrxOqka78D
         HcE6W55fZ6otYzbN4lsjdFBRZ3pdJAqZe2vjdoJsSxDtrDVgPrPMxziW0GCYU/kB7u9i
         3AIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fn0GwhoNH8+ZzMJCJ3+pwW254YPaPG3Wl453zVROsYE=;
        fh=Ij4OnKyjjIydIs1gW3HpVJB/Rj+5H7h2TVPjb9vI0nI=;
        b=eHBojPeKFU2/4EA40Ku3a7MiA5WBfuBczoeeXr8mcIiXwxU7W8CDAk/srW6hhRZDq9
         Gmlhu7E+gs9EkNDi8rC2u8vj9UMPk5ezciTMcUI00eckEWmgyJQk+kRvOnfcpMXYIwQk
         n5Ojdt+PsnVSsXTGnExDz9An1eu28Xe2iixN30eRvJtyRgZknwGycNfY2fayOdb5HFdJ
         ATykmcvTTRZhO9yYNLJ6+O6GcOoerFaIeT/nkFin5QP5l5feinHcmaES9gultnUPne0t
         YdMUNgFmkghQdFobosLHWmvg6cEGujMtNAvbE95CLl6x1nIk9qo4RjKDof7DP7sOl9fb
         ejQA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765844120; x=1766448920; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fn0GwhoNH8+ZzMJCJ3+pwW254YPaPG3Wl453zVROsYE=;
        b=4HMwtqyybSi8yZYMLrEEfGD4uRFJBkT/DEXn2Ueh5IfnYd/haa5UzmCW93akvi7hF9
         84PTtHWkNTtfeuxhHHXQz/pZNQ0VepnEBDSTZvl2P8E3I3Js1/1Y/AGnqcIXY1bQjzhp
         i8dKvGqZwbnLjDz5Fzl/KwAFFA6GCuoopbe88bdMM66TLIMtsRrA0ozpKBB+hp725zaG
         inin4lM7ysX5WnpV2snOxBiJr32kkJFnBcb39dZFJrLvfHYpnnmozHV7G+mcQJe0P5F7
         0ntY6SYsY39DtDwJHI/LzNkAWc2K1+iswWzYuWrfrLCaSj1TMJ0bs+wUdYfMip0rSjpk
         JUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765844120; x=1766448920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fn0GwhoNH8+ZzMJCJ3+pwW254YPaPG3Wl453zVROsYE=;
        b=YpVckBd9CV7ubzm4zf5PxE1LwzUQNyCNITcoZEc0BM+2mf/ZfNMV8DVbK+TWqFUo7b
         ztUuWYG5KDykltRsaa2fbPjwBoC7iVHwIE/KpBciyVB5ZOIx2qnwI3ZPHh+ZaN1ebc7C
         B/Kd1qmu5mqeD8FtsVQ1qZwcIJYlDA6CFLjzMQlQjMKflzDRE9QWzfNU809CU+n7Mrzq
         dewVADc574amsOUjEOwK063yiME5ZLV93hRD8KBf8aeQlpA0LDJo/pRtoEgBLrR0NUS2
         ubWElrka/B4iA3fYJD1dd76LjTkMqnZIjpId4Ch+mIcTQ9Ki/1uxKJFfVW05NBEUzZW5
         xKZQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3aGToNbfb0StfV4kz/0/RoxKyv1CxF2ekuwMPOxGz4vCyRusIz6sJRkOaig7v4nBAOkw34xqCJw==@kvack.org
X-Gm-Message-State: AOJu0YydCGP2uWub1J0MuADrFHb4bmKUpYpw51ftjZUfJC98JkIlfo5l
	Lz5vvFtDDZyTi4PcL4OOYejz4njKy0fHDAnhJaEFaEc61h47HbRBK7YQhzfYKgBc+xemDmNUwhn
	6Vdd2mL7WqEzAH19jFgDLFMk9a4mj1Ns55WuglIpN
X-Gm-Gg: AY/fxX7MMm3JeK7zvkL8l7tm5SDeaHAKmppchKr/HSi2H+RaSTTFgl2yG39tc0KnB4X
	yrPWSA75DEWD3mJQDlBgTKqdLImCGN/bpN849Lqt7TWT7XEJTuCxW6L18d6+OFSrCIKo5KKeRrI
	hlmcuqIRLQ7JtLcvvCtYuIkkhRY5rH96AnSnw2lK4fq6iYgy9G/oVabHpQU61zWvy7dGdrtxz9y
	cAGjMD8tOdDl57YyppIvNXtOI+UrxL779o4CFFNIZ2DZPpddCJ7o25M/jsN5fTdhwNx5jB6WU79
	RjdBsCgFse/tPOq2UtU7QIvPlO1HHgZ3nkSULyA=
X-Google-Smtp-Source: AGHT+IFTOP4Gaoei4VRS4FRMsmoH0dQfq8ttEHezcqkwMWBciDm3nDzocBxJhP2cIEsjUvXgKDFs3tmzZw+Z/7G1Pn0=
X-Received: by 2002:a05:7022:3a8c:b0:120:5719:1854 with SMTP id
 a92af1059eb24-12057191931mr3515c88.18.1765844119264; Mon, 15 Dec 2025
 16:15:19 -0800 (PST)
MIME-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com> <20251215153411.3613928-4-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-4-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 15 Dec 2025 16:15:06 -0800
X-Gm-Features: AQt7F2qPIdqB4YBCefT1YU3kuQHJVylNF8CoP-Km5GjS1ybCK24n-Ma9vuvP0QQ
Message-ID: <CAGtprH-_8gKzLGkU8HN=D54DDffk+mCj_7ymyexN1aDSS31fHA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D696F4000F
X-Rspamd-Server: rspam03
X-Stat-Signature: xkdpe37ptrw8fyo5wue979nszgnfk53m
X-Rspam-User: 
X-HE-Tag: 1765844120-272854
X-HE-Meta: U2FsdGVkX1/TDmz7RDRwNVBBGVK9bb5DpkLqLAthRVLPxMcUMxK0xw4WcNSAH2r+AJA4qJN9ztDJJ5ZjuBVyCcgaAYfTxJxGgP9vluNduqfFmRXcLL7zkfwc5DNjhSrnV6OJp/YTFaj8clGGVSRkuNWeIFKAnlhdHOhnWQ81sfnoM34/cQZeVcAm955vTgRYyXJBjMatweQhPomE4EaB7T9Lc+okL1Irl2Ziqll1dsoMMxjY9EDf7B6S3wfkOoKESqiyzPQNYZi4Gk0WcF+ZJug0smKjYOp9dDzuP6aM7n06R99ok5Zih1maDZ7vCR9P+6Lv4Hlbks5hNCr4vcb+D3vkEW8Qvr67iW5nnhhgJxmj5siynQyUkc/I+0QWXAlaehVBXPt5grA+6kGj8P9Se5jC58VZgxWodX3B51g8smVeG68GM3nQVTox4rinj2ZqIcqnXcFtfh5BawKiYABe301vK16ti0VKl2V42ByzNw8OhNtDuAjTEHupFZIoT5LYWTIoh18ZWYRNlccis+aXDPvXdmM/QW7gCzZYGcEdzhjeIPX8yUW5q/dHco8VvVZo/lqvNSRRJBsR3CkmVpKalVxHNCjTa9AQ7wgNjizkY+CLjfMqeM1KIXGDdHVwiB7myY5qxMp0dyWcYfmhfwLmDitrxlvmOl0rs6ujoLdDp6qhzmmllxYHU6Eo0YDbb0/HndLIfV+2VQHmdn9TAGFjCxSUmXt4cxDGz35HCOF/JGl62wEnjXjY/88ojyJg1anBLFt5yW+N5zozj5tx9zFw+LLEJF1FptAIvfG+Zsjhd9+d4p2W5qypt0IBshBBGAdU+XQB7XLb36CwQFpZclNZtiLxGwgBnK5yzi5KIfZsOehu3dca8lsXaDkgGFPv4+2QodncWuk2tLITeGJAESZ6a0T3bPvC1g5xgWm96y5q7O/5iN9XCvlAdwr9WdIHEvZYcNVXfPC8f9g7Smgcw1T
 JSlUK4Y6
 TFjIlmnyRaDX8n8m61HSgmwk//wqXp9dBz+rZimrSUFC/bvcFpMntu7tKmap1w0GitZnhRToiE8ZN4P/wQwpa75tBp6/ELzlajQXfxcI1xtKh+bPHRY/W2lxzIf1BHZ7+sVEbuY0jn1BTmIFPVH9bVQA0WJjaE7vQWdRn7jMA7WpRSdlPraX0yEyZlBsS1YrebJrdoizcN5CPLR7H7Vu7CjpdUlhGweWxH0MfCWY50DgyuFA8r4VW8kwDkXKTq43rjRrsqit7xWzUZH+397CCPEebMAA9jrRy0nKBlvwDXX9G3RWETvBBGn0YdDXRhSU8Q0zww/hP8UrfyPk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 7:35=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> In the past, KVM_SEV_SNP_LAUNCH_UPDATE accepted a non-page-aligned
> 'uaddr' parameter to copy data from, but continuing to support this with
> new functionality like in-place conversion and hugepages in the pipeline
> has proven to be more trouble than it is worth, since there are no known
> users that have been identified who use a non-page-aligned 'uaddr'
> parameter.
>
> Rather than locking guest_memfd into continuing to support this, go
> ahead and document page-alignment as a requirement and begin enforcing
> this in the handling function.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-By: Vishal Annapurve <vannapurve@google.com>

