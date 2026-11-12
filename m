Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4284606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=reTmOVlv
Received: by kanga.kvack.org (Postfix)
	id C17626B0605; Thu, 12 Nov 2026 17:54:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF6B6B0607; Thu, 12 Nov 2026 17:54:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE0D6B0608; Thu, 12 Nov 2026 17:54:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 85CA26B0605
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:54:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B35C121E12
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:54:00 +0000 (UTC)
X-FDA: 85427971440.03.32EF62E
Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id 33860100009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:53:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=reTmOVlv;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794524038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgCptcuZZGnpucb4fECK/T2UyDqZTc9e1G0OWT7xdqE=;
	b=jH8J+vJLBf6vbCyujVcU4zFzTMVNnf5BEthi/IJ4FiEoAzsrGN6fUIjLHmtyJ11rXx635T
	YSLjYGsEL00m3HQSAxM4FTIeMxj3iLqUAW8INkCq4x/Nvk5dMN68SEg7cgiqhZZ4Sz8YO4
	nNhEHVoL/Rr88h8msiPt8lvwxoC+oHM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794524038;
	b=5Al2zOO9nUTQaMWzO4+S3uRqdO7exj1Qe5vNUAzYwg+q2SNw3reLr5TSPg1mv8uiZfKmqp
	uxoNwYsafX286s/ro25+CwB6HLNlCLXoSE5W40RHjoQFP+UDwVZe5U/wLlCVg6etwkA/Bj
	Tisx28z1eFdhUQhiHDc7j4I76NrJbTg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=reTmOVlv;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=D328/T0nVzitlMJ6wPyxR1Lhhdb/AQX3JPpMIsUkE0A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794524036; v=1; x=1795128836;
 b=reTmOVlv8hrEP0zpP2LKa86uX+BQwu7f7zC0ydXo1b91mpvLLYDrFO1T9XGxA44pAybcu2ga
 uBqPbDxDvo9P+mGIGJCHaJnBagNeg0Kw8696tmr3zmuWVE5t5h6nk0JM2JLogagau6EAW6VugiO
 77p5uJgaaPUPUOYlY9rLJN5c=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 91056c6b94e451fd;
	Thu, 12 Nov 2026 22:53:56 +0000
X-Mizu-Trace-ID: 91056c6b94e451fd
X-Migadu-Flow: FLOW_OUT
Content-Type: multipart/alternative; boundary=Apple-Mail-1454BF9D-3000-487F-A89F-13518DACB4FB
Content-Transfer-Encoding: 7bit
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
From: Roman Gushchin <roman.gushchin@linux.dev>
In-Reply-To: <avYJ-CxBEpdO1Wmu@gremlin>
Date: Thu, 12 Nov 2026 14:53:44 -0800
Cc: sashiko-reviews@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
 =?utf-8?Q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
 Borislav Petkov <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
 Dennis Zhou <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-Id: <816E22E2-C7DD-4DD1-AAC9-F51F4D1ED71C@linux.dev>
References: <avYJ-CxBEpdO1Wmu@gremlin>
To: Lorenzo Stoakes <ljs@kernel.org>
X-Mailer: iPad Mail (24B119)
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: pywrdpusqxyo9aezw3jrgqefnxu4fdt8
X-Rspamd-Queue-Id: 33860100009
X-Rspam-User: 
X-HE-Tag: 1794524037-624532
X-HE-Meta: U2FsdGVkX19UyI4sXimQI7MDFWK1lxEJdgiJp7H2PjXU/00gH67fvNvWkaALkdCcdqauz5e+XUCMwYe9TfThORcabqDp++2gw7wxEw5ERYnjpOt7vDEh2zo0F/6nUq5i+M/z6aYuiJxMUVL6Np9AYIW8IuWWmOqJisFbT2ZIR710u04LzuzWXkWlKxaUWILVL5+8BoDseMMshsAJvmbRGmFnvfW+w0jRGQhwbXlEy48vnFmPS+cqa8Mobd5oq0oA4eQwrT6K6OQAtXdPx7oxds25meY6i8dp4xbnmW1xEWN0DP876edSa4mgNkqZlUXlAxS73o/vwAcmC2dRstmroM75vZc/GVQMv40zuVFhhosS65EPzQB2etSwjjGN2tMF/39dBkIPPrXxZQmMMHv4I/+eUPf5IzGJr6SRVkcl9YQmarBAQhNk/DaFLUvFLUFHTEh5fpgebW4X9cVASML+G08YtzZeOmIXsqiiRjsdpsG5LHDOJ/NTH6zWZyfdaU4TdxwiBUIgj4zO2Fg2oyWU5isfXUmytsseoV8ZTYoTpLjsCojbGEJp+/K+JfPF6TAOv6MzkVJJAM7k34mNxVVQhB5QlwGSxas3ItTCAmR3R5di1WY6AcpN1w2aHpG7HET0UWYeh01KSJj75w0nWabN4m9YYmvyhtEa00gGDNs83zDFVIeqX45jFURVVBLfhaTal3N3dIC4ZCilh3XcesILf6u+I5gBPSIXSs0lGA1r3H7dLGIrLMu1tgNyO0IjWoqA4q78mMQp999XGjcxhFaSpPKbHyqnOO2fZ/DyCqnH1CyiGVyOUvyiq4YhGeRG8rGZTJ/BN9sdAxfiWfLUGAInSzwxCznUdDLuPjfynzywMaMgghGozG2qn3st7CowMZyuqjDLhJ8oTZWKLhKQN/GGcGielu9GFPEZSFG/+ywmyctOmqq/DCK9y89T1lX20oGRFM4K6h/Feu+qTR5cadS
 Rj4KUfTt
 H84O8F5xsJdL+XCtIhneqOjYLGPBAafrLDMqM9QS/JO4AvQytvjmqK4kDTisv+FMLQfceqeqTd8I814EkFDWkt9rjNz6KagVD43fR1tGijlo14Avu/HN+Tqo+00E/fgG4S94OnX6L8Wz9VXZKvxcIPMO/Pp+6iAaDQfwbv+IPhUW3n3jGfdaCnhJ7ZWkRZHkk1jyKm88HcqVnLvDfVmgWMCh4PE1Lg5S2YbTvi4iJLq/1BGoIDg1cWVcw0593ZLf68N7yyAocrYMrvJRWstahAAOmGUoW0mF37jE0d2s3XE02QM6+udK51UzaKziVrwNA9tvF9oJwlWHjoN31J4+Dt31T9EWbRKoameHGTUCtM6qcZfHRLaBW0UStTOcI76kvIMFHDYHN+xXKoxkSf92aFH7fyoYLdTImA83KHKLUQHaxWlh2BiK1+OjQHNnoUPRtXFywGXgussSOXmp7eXF85/h3JbEReUIkkq7fi4kHR7I+pCFdErzKjzANT2xQTM7jXh9W46zmDFKn/ryKu0su2+UztR5jNCgsbBKnj0HjuFrrsChKnDc2CzA2Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Apple-Mail-1454BF9D-3000-487F-A89F-13518DACB4FB
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On Nov 12, 2026, at 11:03=E2=80=AFAM, Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>=20
> =EF=BB=BF+cc Roman
>=20
> Roman - see below - I was under the impression mm was not supposed to rece=
ive
> 'unrelated to this patch but' reports? Did something change?

Yes, sashiko started reporting pre-existing bugs again, but in a better way:=

strictly once (per bug)
only for the first non-rfc version
somewhat related to the proposed patch
not more than 1-2 per patch
not exposing security-sensitive stuff this way

Obviously the goal here it to increase the chances for the problem to be fix=
ed.
It=E2=80=99s global, not mm-specific.

Thanks=

--Apple-Mail-1454BF9D-3000-487F-A89F-13518DACB4FB
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html class=3D"apple-mail-supports-explicit-dark-mode"><head><meta http-equi=
v=3D"content-type" content=3D"text/html; charset=3Dutf-8"></head><body dir=3D=
"auto"><div dir=3D"ltr"></div><div dir=3D"ltr"><blockquote type=3D"cite">On N=
ov 12, 2026, at 11:03=E2=80=AFAM, Lorenzo Stoakes (ARM) &lt;ljs@kernel.org&g=
t; wrote:<br><br></blockquote></div><blockquote type=3D"cite"><div dir=3D"lt=
r">=EF=BB=BF<span>+cc Roman</span><br><span></span><br><span>Roman - see bel=
ow - I was under the impression mm was not supposed to receive</span><br><sp=
an>'unrelated to this patch but' reports? Did something change?</span><br></=
div></blockquote><div><br></div><div>Yes, sashiko started reporting pre-exis=
ting bugs again, but in a better way:</div><div><ol start=3D"1" style=3D"lis=
t-style-type: decimal;" class=3D"Apple-decimal-list MailOutline"><li>strictl=
y once (per bug)</li><li>only for the first non-rfc version</li><li>somewhat=
 related to the proposed patch</li><li>not more than 1-2 per patch</li><li>n=
ot exposing security-sensitive stuff this way</li></ol><div><br></div></div>=
<div>Obviously the goal here it to increase the chances for the problem to b=
e fixed.</div><div>It=E2=80=99s global, not mm-specific.</div><div><br></div=
><div>Thanks</div></body></html>=

--Apple-Mail-1454BF9D-3000-487F-A89F-13518DACB4FB--

