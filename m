Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2F81CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 15:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0529C8E0008; Thu, 23 Oct 2025 11:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003FD8E0002; Thu, 23 Oct 2025 11:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34708E0008; Thu, 23 Oct 2025 11:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D17E68E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:49:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87B6CC0BAE
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:49:07 +0000 (UTC)
X-FDA: 84029812734.30.DFAA874
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 654461A000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:49:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=dilger-ca.20230601.gappssmtp.com header.s=20230601 header.b=HbFsUazU;
	spf=pass (imf19.hostedemail.com: domain of adilger@dilger.ca designates 209.85.216.44 as permitted sender) smtp.mailfrom=adilger@dilger.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761234545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6l6v5GKhdHV57QLrRcfX0OseV//0wL094GM3Lc9kONI=;
	b=GwSlhI0fWZY9uqhPZzOavaIznoJaSbyVEkjzht1fao7qYwfFDa0q0BuCdpiFYhYGcxr1dl
	7c007nTs+4X44W2GPwSzVJ9/FJnUvXU/W3RI3oEqr5zTETyWeIJLT/ItEve4Dl4YmLztrG
	L1W76lk1efZIQYCVdEN0XuPqDGxCIwo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=dilger-ca.20230601.gappssmtp.com header.s=20230601 header.b=HbFsUazU;
	spf=pass (imf19.hostedemail.com: domain of adilger@dilger.ca designates 209.85.216.44 as permitted sender) smtp.mailfrom=adilger@dilger.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761234545; a=rsa-sha256;
	cv=none;
	b=kUFOXlZMqxu7D1OuRnpe9t7AxLKpxvEdClA96v3Es77Mo+/6XTng/tK2foctQy/l+pEL4E
	x6P2++aWsmCV0yXPlQdx1vuWkkMhVtpwm1yeRIBHxv7On34zmC/MpU6jSDzH06HcxQLQ1S
	0gMaWTw8ZrgTiPNEDkDYEEHUQY4TOKE=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-33bc2178d6aso797829a91.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1761234544; x=1761839344; darn=kvack.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=6l6v5GKhdHV57QLrRcfX0OseV//0wL094GM3Lc9kONI=;
        b=HbFsUazUtidxnpLGvwSbRPOR29Pke6DaW10VqZZHtFTAmiFSTGfQZLf4l6MMfWwuCP
         Er6YQZHKLCv/X7QAdbz0TLV1oCjab9xit/cLRFrLd+HgiDu/lYJPp7lFBtOGsxsTIY6e
         eEezWBOkTVfoMKZucSIQxdv1MF4MSAtZEz1udYUsCMGMGNVSLqzR+Upa0PNDnV2jBQbe
         xHlRseO2Bs8lvyuo2Rfq/Esp9AZDbjwk+POa1ceKyqL2e8zvCxMs66KeUu0SVAhNibWo
         pzdZd+00ZuVUa+KmXikzDlunidAQWKhlt2+bV3sPwpb0wJzv/pRDwOebmQtYU/qW6zxa
         FPpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761234544; x=1761839344;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6l6v5GKhdHV57QLrRcfX0OseV//0wL094GM3Lc9kONI=;
        b=k4XpnICNmR9Ji1hi8chiwuCieVsasIWbRRrPEhYuTLIswacR+0toMyKI5bSv8gkFI8
         lvGs11jUQG5rUJrLAxmApvbqHaMC07AXSRlwfjLd7KbSBCyZ/ATRWMg6bE4swMBeBSGf
         t9aUCQZyzB7eNXfsXOYQtZoNmCMyJOpW9CrBV+xKZspzSUXT26O7acHSKQlR2iBpVJNw
         8SnhAWa69VHuJxQNADXtxHjynh5afClsLLvO74bI5KQRvIHX9bES7znl2HiuJhOsppRL
         iWLCsEy3g8o46zE3p1EXQJ7wKJd88UfZhKOg6/JE6tMdslhKaanpQbQnPDkLWlrRXs5Q
         sa0g==
X-Forwarded-Encrypted: i=1; AJvYcCVH4u8agprrfVYYJi/qRsMpdtBIsKCr4cPnJOZMCDrn8Et+bvzZNVayVSfxBVVDGRClhew5gqInGg==@kvack.org
X-Gm-Message-State: AOJu0Yz8SEANJxWxF90hF9dt6BHgIL8azhmFKquAnKOyeAFjjZnIhGZm
	b9LqAWgXxL5yTTAiW9cM+iOHrWgQZuO8dXgqbfdl1Qxpu2N/bQv5dukJ3uZeQdeBfQ0=
X-Gm-Gg: ASbGncv9rSN8aiJ63DaDlkwA/KZpJ8gfsuec+dgMrxuU/sHBzgcFdyF0UrmvhYjo7Gu
	EAGYjPiOjTiCk4vylbZ8Yz7/kjk8sIysG1JTLb25XmYSvxReGxyDbeI5XE04XIk17H3SgZc6PDT
	vemXEFhOA/P6DGSnvc2H/voL74XCqHYPHYa6pQ/s3MNlT+Gs7+flMQ5XMa65vKIbzKAX3giBKYm
	fqA1hv3mlhG19ZAhUIA28P2CPUrcsARiS5pqD8FxpUHDX9FVexeN+qtZ6Q9Z85DsvKSBgsSkhKr
	D/qr3q1jZ0optsvNkTTpxmocQEVQej/ZboMmGFvRcnbwDJboIBPbqhXZB6HW7yzuw0GYwPfaVHI
	+yu2zCv/GVXwec0/Hnh/42OtBQlwnnTnH3PXEaUMCJrs1eCzf2nh7ezbrbL8e+8FJxG+opDNaUP
	j7GRetl9vaSTq1Plrp2brzHSeTjizkGh6ffhpap66SwqzKpJvK
X-Google-Smtp-Source: AGHT+IH3PwWqpiI3zcpwER2AyB/rp+AS9Y6D6TVLAKwCB2BvEfgzPHpJN6qvv4GuH89JR9PFSabRKQ==
X-Received: by 2002:a17:90b:5291:b0:32e:859:c79 with SMTP id 98e67ed59e1d1-33bcec1ab25mr31330207a91.0.1761234544113;
        Thu, 23 Oct 2025 08:49:04 -0700 (PDT)
Received: from cabot.adilger.int (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6cf4c13d58sm2446777a12.15.2025.10.23.08.49.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Oct 2025 08:49:03 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <AF891D9F-C006-411C-BC4C-3787622AB189@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_48E99939-A914-48C4-B30B-0EEA6EDDC0B0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [RFC, PATCH 0/2] Large folios vs. SIGBUS semantics
Date: Thu, 23 Oct 2025 09:48:58 -0600
In-Reply-To: <aPoTw1qaEhU5CYmI@dread.disaster.area>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>,
 linux-mm <linux-mm@kvack.org>,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
References: <20251020163054.1063646-1-kirill@shutemov.name>
 <aPbFgnW1ewPzpBGz@dread.disaster.area>
 <d7s4dpxtfwf2kdp4zd7szy22lxrhdjilxrsrtpm7ckzsnosdmo@bq43jwx7omq3>
 <aPoTw1qaEhU5CYmI@dread.disaster.area>
X-Mailer: Apple Mail (2.3273)
X-Stat-Signature: fkjnmxu4xmcsafahu9dxf8ra4onztbzo
X-Rspamd-Queue-Id: 654461A000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761234545-945196
X-HE-Meta: U2FsdGVkX18l8WhnlvnR/+n6W5s8AwzOe5cwdd6qJNRSl713bzul8ZUBezU+5GroCkMnJOucVjvlFiL1KNTvYSXHEddjFJCnUgxHPeU3ZuM320RGxGwRlKiiqe9n8HDJg2e05KvrCP5vsbKFeavs2eYNwn89l4QXafjme26zFQ9ll9KMkwtFwB9VkpwdpOkVZ/d+xKNynGJX4abt+UHaoaK5bJqhc+XXjBHHW1anokXIXMb0wVEJCPwmyKpPbr4hC9tWSZytrpQ74WcrjJID5LqWGe2WbNZIan+OV0Zxo+V3LEqUaGqumjPZPaaRJDfJbV7T2q2wR56yys6I+xxOrezciqDOzO7julNu1VueE0iGRQ/Z0ySxJwWMI4VT9nWYqcarjG8CL+qVNl6AgLtp3z2P+PbUTGst7cq6khRN8TkO422ScMM2dn2ZcF6OVkvTd1YaeD+kIKE9CQi9I3b7Z/KZR9IBdmxwYDnukhWsN7QrmQJkYB0QID8L8MjPDtLmu2ken1/lHjpap9zx3+oZZrnc4mp6HPaMjiEPCGfZtFJd1R8UVWpbkLBCTeLZ8k8Y2oCLGqMCJTe8Y4Jo9oj6jaMuKuJjK9xmQlIoR5OQbtNF/UCAv2X4ZneJyOE94FQCvTTf0BBZ1Ar3MDFkM35g3p1H/JrWYg2T3wxnd85Ibku6Ctpa7vsiWtWUQuAQnrAryk/vwAsTv+89oXboXecufQsmXdLs2tydfSTP5XVZpYs0AX+eDBPiKPwuNmYCF+tBppaBqyBE2xrMdmzkQwDDpvzpIhJSYc0QiDUUHvBZvkRpE9KBXkhiIRWcz4WlQiqMC9j8uqqfroTQFrR+i1BL559oqoOtmIA4JfCDydpRHviBiGtO+n2cufSGv/5f8OERkkmdoHbFoS+n1CzCQCgHA2MxNcxDp4NzrP0ECxIiXEB/hig+e7WDUVSUdaNjCJBvG0x1K02PSL5LfjXHTlv
 C6ddoO9m
 Zj0ynxgbb3LWPQhIBehgSLUbFXWA7gpDba84DPEsRJLyi/9UUfhV6sufUXzGcXQ/bQO9ZdxrvXGGuqOLFjZ2XD7BBvsoXtPUdksyAg8qFJV+qkhA78rzhen6xODtBVBABHxgsMO2AKJykz1J/limyyoE2TyYz7ZvQy/H1gofNfc37JvS4abeeCp6dNJcvPnK3nnq+SS7yrZBZWibQBnUtVEwD3kyyg5l1DvrrmSMk+hjoCVMcEZWHxg7xDEcoLS6MOFjxawdZ8ttVD3O9CCpAHDu7kzVlGr21YmPsI5jr1Z2UQny6xvZBBJaWl/01TkRMLumaljoDVV+SxJMlodZe0ofBPl1g3ZZYnSsbiSBAsKC5m0x6jn+1MYVJnYerMwMk5HhUzIdDCueBPgduaFhaHo2A2r1o+l5HL4twHwWG7o9gz7MCTHnkOuS9vfCOTbRjWhSx3GpctHOw17X8A+8+SExAMj8CLbwnMWZRJ1tvWOJRRCLktizFp4Ufymj5uID2TWIbpsqOEAs8BT6za6MTvRiqG2OeDZxd+3JaUqghcox+n80=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_48E99939-A914-48C4-B30B-0EEA6EDDC0B0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On Oct 23, 2025, at 5:38 AM, Dave Chinner <david@fromorbit.com> wrote:
> 
> On Tue, Oct 21, 2025 at 07:16:26AM +0100, Kiryl Shutsemau wrote:
>> On Tue, Oct 21, 2025 at 10:28:02AM +1100, Dave Chinner wrote:
>>> In critical paths like truncate, correctness and safety come first.
>>> Performance is only a secondary consideration.  The overlap of
>>> mmap() and truncate() is an area where we have had many, many bugs
>>> and, at minimum, the current POSIX behaviour largely shields us from
>>> serious stale data exposure events when those bugs (inevitably)
>>> occur.
>> 
>> How do you prevent writes via GUP racing with truncate()?
>> 
>> Something like this:
>> 
>> 	CPU0				CPU1
>> fd = open("file")
>> p = mmap(fd)
>> whatever_syscall(p)
>>  get_user_pages(p, &page)
>>  				truncate("file");
>>  <write to page>
>>  put_page(page);
> 
> Forget about truncate, go look at the comment above
> writable_file_mapping_allowed() about using GUP this way.
> 
> i.e. file-backed mmap/GUP is a known broken anti-pattern. We've
> spent the past 15+ years telling people that it is unfixably broken
> and they will crash their kernel or corrupt there data if they do
> this.
> 
> This is not supported functionality because real world production
> use ends up exposing problems with sync and background writeback
> races, truncate races, fallocate() races, writes into holes, writes
> into preallocated regions, writes over shared extents that require
> copy-on-write, etc, etc, ad nausiem.
> 
> If anyone is using filebacked mappings like this, then when it
> breaks they get to keep all the broken pieces to themselves.

Should ftruncate("file") return ETXTBUSY in this case, so that users
and applications know this doesn't work/isn't safe?  Unfortunately,
today's application developers barely even know how IO is done, so
there is little chance that they would understand subtleties like this.

Cheers, Andreas

>> The GUP can pin a page in the middle of a large folio well beyond the
>> truncation point. The folio will not be split on truncation due to the
>> elevated pin.
>> 
>> I don't think this issue can be fundamentally fixed as long as we allow
>> GUP for file-backed memory.
> 
> Yup, but that's the least of the problems with GUP on file-backed
> pages...
> 
>> If the filesystem side cannot handle a non-zeroed tail of a large folio,
>> this SIGBUS semantics only hides the issue instead of addressing it.
> 
> The objections raised have not related to whether a filesystem
> "cannot handle" this case or not. The concerns are about a change of
> behaviour in a well known, widely documented API, as well as the
> significant increase in surface area of potential data exposure it
> would enable should there be Yet Another Truncate Bug Again Once
> More.
> 
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 


Cheers, Andreas






--Apple-Mail=_48E99939-A914-48C4-B30B-0EEA6EDDC0B0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAmj6TmsACgkQcqXauRfM
H+CY1w/+JoC6DHdgP5p4CEVNhByOccTqDc9/xK5kbk0cN1d/jNA0jaz3s/jLATWn
DMDa3ZsuYDyYNk1KhlbLNZ/k1MJEh8mxq4pqUrmu4PpMFrO2037t0lkPdYxcakkW
+idSJxoIYQcCGS42vOUZ6gL40RIRLDdY/5zgCvysIF4aIbYyp/NJj58BBuzHahC4
MlejI5KKvqxYtvhCeCt0lGbSc4a/rmoI02hhKngMZ865oM2sEdSNQpjE6/J9COz7
XwbWqa9mth0aa5vuUt/RcL9jkFshItIUmhs4DxUtdHfXPSG4hDwM0jsJnNdRD/SM
RQY30IoDVBoefkwdhs+fvGbUivgw0LSgba56P+AjLChp6FAX1ASh3ML+4zxspqs4
fPxiX7BS7+ojkg0VtKEKJPk5Q6+4a1T3flIBq6tDE4UwISC63Vb4qA1CPCVbyVeU
zKAkfNMzSOlOMOYKAj51Nx9mj6NxZXLJvrS7jMCKiWh1m7B6a9GuDs7yQ5QQ+Q5v
PfheQd2jmcYXXRZpyzu3qhzJzPGpJ6seMJCZHwBQ3jg2zfiv+7gyGwedVKy/xb+j
Cd2xi0wN9hrGFKO2Ya2Zd7VIHkkWnjErwOm1x4QNsiqj9D6Hc9yJkHCG0dRb1Lwv
4064fTxGFyNuIujVcvPB6rXpKVJGhLEayMqrVtDjuzoJtA9vQJ4=
=kl6f
-----END PGP SIGNATURE-----

--Apple-Mail=_48E99939-A914-48C4-B30B-0EEA6EDDC0B0--

