Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA95606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=eQYdpnhS;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=Ka2idx3e
Received: by kanga.kvack.org (Postfix)
	id 9FCCD6B05B2; Mon, 16 Nov 2026 14:42:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4BC6B05B3; Mon, 16 Nov 2026 14:42:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C286B05B4; Mon, 16 Nov 2026 14:42:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64B956B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:42:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4D9F4015C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:42:36 +0000 (UTC)
X-FDA: 85442004312.23.5F07C9F
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4E810C0009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:42:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=eQYdpnhS;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Ka2idx3e;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794858154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsV5fz/GetvcK4qfUxJCgNAEtXbvKRxmLJMOtlw7few=;
	b=qckfrLvXDIz7uQO/Nk9rqYMqUBPTqYEmkSt+QSCx4xZ5dg3RmAOFuimQnnXuHDpMmYgeLN
	IyRYQvjYwe/0/M8cNntrwaW4MWPfsEXpffTligWxiIzw+Ulz3EFkRqPcSwbG3E3IlQAXtK
	Sa9DgRB6+ILXwCAV9AUhRC0o5DGF4T0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=eQYdpnhS;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Ka2idx3e;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794858154;
	b=m4CxmKjqBBwVs+b/8dXn2CystLjBoP/aH6ez2dpEiH9Zm27qQuMHNgp0x/yxEtIrK+5hJt
	EFGKLR0r+FfVJX0DH96yiRpAtdp+XMsYmGXFipAAS2Y7OAuGAbtYAt5PlhIVpP5d3Aaq9n
	eee4nHIvtGDjFZBCSg+NV/cwQIE82VQ=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXGER715775
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:42:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=rsV5
	fz/GetvcK4qfUxJCgNAEtXbvKRxmLJMOtlw7few=; b=eQYdpnhStgsz1ZARwYMw
	SZWyfH21wyxWchOhNuaMT/qOqp8F0Sq7t8jp/0r9X7F3mRHMF+0MVkFz746vxSXx
	PQmB/g95c/MwKXZVcERW2Ybproa6R2b4vCyPIIXNVljQvMytOl6A8DqWTrqe/+c/
	n8Ff5v9HqrDSXmN3eaRr3Tx6UqpMRKu66pJrFj6GiHOZb5PYMux9dkYdkprCQvbR
	4Nj15DuO+H5ZTUschfW84UQCrh7xYhDlZxqic+Opf/dS+q4kNZrn7Pgyn3nwQUBt
	pgg6Xke2UK/hPbEDGSNDCgzH+w6q0PGkq6ji/1Z809wtugK+T5lsOiURv6bB/Nyh
	Zw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j059qsw26-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:42:32 -0500 (EST)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f37c94ceeso32430485a.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794858152; x=1795462952; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rsV5fz/GetvcK4qfUxJCgNAEtXbvKRxmLJMOtlw7few=;
        b=Ka2idx3eIXVNT6CDi4gzXRJ5MKDhR7UZEtFaLXI3ckcrwYGkns8rEgnyMDtPwWEikB
         /Pawsz1agl/dgnqKsLWhNME7HV+jnX5fvSJPF9wltg6tOekdjthcYrcFAEgI5ITm48RR
         XPYij+pyMpx7Ik70Kkysipj22EFWaYIhopMhp+8IaUBAXTeg6vOvqJv4/KbfyS+XIhAa
         SSmA5fq2HoTKqfdlOwJPH1V7+RadtiE/NqoGdwrfUU8y9RH0arBwHauk9Q0Prr7n1ev0
         ovPu9cvUBP0GPbVQGa511Xbk8Xp5YkVRTfu4kmjK7XzQL1EeyT23KWXirU9vhZxz+fnu
         ZHmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794858152; x=1795462952;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rsV5fz/GetvcK4qfUxJCgNAEtXbvKRxmLJMOtlw7few=;
        b=QtbHd0UGZoaxXz1/+duPvuudfWa0mcJsAZ0yoWjKt9/2cKjj6d4mYp8Ebnm3GKqonr
         vZrYQxVHCM0qp1L/JCeDwCPdtuz4VK/+TwlR4/1rgclooK+7PbpMK8PcB/GTH3anlqYt
         +Bk76GofQLrA8uYaDFs7XELYaKjpkF8Koda4cgTuTo1JONttKQ2NxnuLDJrYVvClvgOD
         Yj+b5r+hNVDTLVFye6paYmT1dW8pcTB8GhVXo8fcXUDX5eRoJ7YT8p1Wgtmra6nlSERe
         +GkjgnjbWGeQW3cfMFvQbUFsWV3WQ0bxYEpJExTScK+c3NglAUkYiL2a8RNnrScu5c0S
         jI1A==
X-Forwarded-Encrypted: i=1; AL+hErEAdswO3zE0npL213//dCP76kPOQ75mymH7bhcoijqbtBnibWXCtSoPZwge9VuVs68i/zOiRqh6+g==@kvack.org
X-Gm-Message-State: APuU4Z/Z0aAQXmKPU3YJhqrSP0/E6JO5Fdh8uxPdJrx1B6M2F9JI8ifH
	1r2cBr/DtO8/TXgHjNulIS5CHAgpt6vZzara6ykkun61UPinU0+ZM5zpL0h3mI6Ud2+rmjNmVSW
	WggZ/BMFRTyCbrFwKZocXx4nwijrxV0R1a8XUeAhz9slVbMHp
X-Gm-Gg: AYBFou1eJ0uQPSklHfDXvz/bxBTdrd8wUaaVER60NGsiZvdxTOvp8tJeFYmE1WJIN3L
	B+3m7m6cOyGiRS6lEhEQrzD8B76D3QSpuqGlVMh8ZtvyatetVzNIT9nLs2Wi4q9msgmt5oD3SxR
	fHulNVIDRNmUQ83z4BMv8P+ZaZM2C72Xek17prZKrg/3PB7M1U+/4EAWUtrsRxrquybATq+5fao
	jOoxmmKydUW4PTuIyHZaePAKaHhXlYGxVD7kF0qNMsZmofwXgXz8Ie3esdaGexE/p8YaFHF/Gdc
	r8IBn9B93LKbIWB9v8weGa9sbvSSd+KPnQLYl2wcrT3uh+0itttKC9A6PsEwUi3yzAfwf/seU9J
	4YM78JH84/LgLmgLrjKFO+Btpli1BM+MiPqPLd9ibQp0tPkUMP5heQ1xTfYOmQm+6hlqnemcY5s
	fzIQrBgt4/JoQva7+1V4gpgKKM
X-Received: by 2002:a05:620a:8018:b0:93e:5677:317b with SMTP id af79cd13be357-9498b91adc0mr77551185a.25.1794858152259;
        Mon, 16 Nov 2026 11:42:32 -0800 (PST)
X-Received: by 2002:a05:620a:8018:b0:93e:5677:317b with SMTP id af79cd13be357-9498b91adc0mr77547785a.25.1794858151779;
        Mon, 16 Nov 2026 11:42:31 -0800 (PST)
Received: from [10.207.2.125] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c608c5debsm23147293f8f.42.2026.11.16.11.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 11:42:30 -0800 (PST)
Message-ID: <c2f81bbb-ea3e-46d9-9c07-6786bd186797@columbia.edu>
Date: Mon, 16 Nov 2026 14:42:25 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] mm/migrate: keep the uffd bit when restoring a
 writable migration entry
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, leitao@debian.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-4-00713d368976@columbia.edu>
 <avYG7CtQ52v3I8tF@gremlin>
 <f28dc841-f664-4f97-9dd7-bffd2825115e@columbia.edu>
 <avsV68cP0rp5mWSf@gremlin>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avsV68cP0rp5mWSf@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=L/qI0OT8 c=1 sm=1 tr=0 ts=6afb5ca8 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=eaRlbwK1kuk26zd7Q68A:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: UH034F91My7AQSquYE7fHXWZTtrjy2kk
X-Proofpoint-ORIG-GUID: UH034F91My7AQSquYE7fHXWZTtrjy2kk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA3NyBTYWx0ZWRfX7s+CAvmoAz4F
 5Z70ynsFwEeRQdaSGhTvGs+3ws1CFhxn3LNk64fq71g7TF7a2tQLUmi5pTU2ZyifIF5JtWWJKwy
 e/uWrB999TdtTbE5JVFWGS8lARGeS9zf+PU7cVmL9jpbq/3bw4WpWvBhnxFSUOfsCuzHDXP8j40
 3FpYKRqb/aSQkdX214hpVoOkXZtlP4ZSjQwpb+jL5NivP+XnIiEdckFexkYwnTfseqCO3MvygSO
 caDtERTIeFdHGreUg7ThukhZcJLdTTRKxnrbiQ295p/2frPQxVP4FgtQ+czkqkULBTwNQsJyA6K
 LTXRV3UN177JQVfWFmfpHC2DVDzTq6sLg/0zK2urRmgpvBqGqyvIU9ExJqgHbnoYwlb+ygQgvPD
 d4+RXRZN0gLbWRZ6VQfhVD3jjvj8DbRv1vQxdhGyrTprh9g4btLZ3dRVCouSIY4/Lxclmy2FyWZ
 DH7ANgD916W5NAjzJgw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA3NyBTYWx0ZWRfX2F6+xrw8VZgo
 vkPWCgLqNpgoLUIqAa1jG68qufgaw3DiBfANCWycZiZZYxOMNJDGgMn8EcaQinESu1HBRrI2Idu
 cuo/aTbw+kFWdWvqFvBPdPcRbAAbvr4y6Xusem3fTGp1hUd/SHAg
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 lowpriorityscore=10 adultscore=0 priorityscore=1501
 malwarescore=0 bulkscore=10 suspectscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160077
X-Stat-Signature: z3nnt871zc9d6f36g41rexwuemuwir6q
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4E810C0009
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794858154-44957
X-HE-Meta: U2FsdGVkX18dUOo6d3aJHAe4nRnlzSM7cAHgLEAW1JubZ5/ojORWOzqxbhEPFhcnRJLszLpQEZW7tRf9cPNKCg4LmXKVi02Kj8IeMGWjY7XAlMNt5eON5yx554z7Em43MsE6bAhFHXhM9dW7rn4GLZnbVlGb03fvXHFp8kn75ejadAddIE5AAVURs2v1gMH26q84VJ/pWUcgHtbfz+ytVrtnNT/kxbn08tgyC3ZHDoVqMdfs67cQFoWsC2dRQTAl/1jFLpoqRxMcoXiQximShjXefuHis3Yd74FPtgdoXjZCrZfme+n1y0cPsJUWNKkWDVFN39OnIpLYsstCey4d0qnc4pB0Z/5wrpzf/v5zxPa/n3Msf0bPHLfPSjcZMrAlnG1emHafEph7HrNyqLTXcftqBp4Ywb8iNtgV7nPbbW6XUnN8p2t9O4DhPlt/3vDFL/pUfr/hpeuz0J9GcJyPBtOlKkWxilZyRpCyPoGw/bAPNFkWgFFyFP/3CLnaY0BGiG7w+0vMoglWG7tB6FnQ1GyoTqcH3BD6FsGGYlYPnxH50UI0Ma5g4/8N9WwJkjZzlCe8675BszW/LO5iwHyx0xrx/5zHhsBei3TEqQ6+hYKy5uTkH6gW/7TJ56hcN5AcWkUVR4owNzsqWgZr5sKNl/dN84p113hU7DIN92dnkKJ79AMwkaz2+B33pUELe4oU5g15XI1pc4iFQe0Fa3Ce9hhCx2ORflQBz7pGBC9kdcICUS3FdZYgtDgV53JTh7kedKXPWJfPNxE3qShS5BLZnWa+2P1EnQ8yC4czisoqeNRWBS06xeemFCPAuU442DMrHP2e4eE6U3M4p1nR3d5UaQQZCQKUrL+6X18zOHm8HOZjDd8Cxffk9yIKBYxpvPvlqKpMS2XHCDN5ZLJ1ZHRaGw8kmAtKnoRtUjgEXjgBZw0y2mXnwQ4CvnAvgf7s8uC/7Xcxri5SSBE6GUZAN4b
 OpGsa01u
 Vp6DCtpRqisUy1LPZqR8mK546avW2ejvm4AHEhyVdLHh7mYkY5KXPsibhDRESBgo0hOpPiB3Ru1Nd8lBW0gN2506mJ2zt4edsKMTTaWeInLC1QeTgdlVTzSUG1Im+N5+cGfZH5y2wW1R91RHaskLzuEwoggbzkP74D9uRxkpu+bgtukpstonzYYyitEipUGnq01KN9D2YLEPjTTXZvrck9AzzTEc/7AF40GsB33a7juMsFOPB8gT0ncRqP30gSoOaPH+yjSly4alegOnHa7tDAr1LjlhgoniyquupcQDbY4/mwTnvwvUknV/Ez9S2M/djyDIdNxtwW9nylDJQBgUKZ41CIyPk8YZqsXuKfCJHLBVUdZDoyc1I3w0J++P1dREGgF4qPysT1li8+A8hlT4+rPeDI594cuvG8yoRFj0jf+mdvzI9vo0onXYxwI5xoZ1Z4EdflQbICitgOo12jUOq5EZz+M+yttL/XHWeVYhv2F+b+2RW9KIZqu8Cru3f5+Rn8wLXX5AciwqeupCkNkkurnFF5A1uukdnoD4x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 9:41 AM, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 13, 2026 at 04:59:39PM -0500, Tal Zussman wrote:
>> On 11/12/26 1:44 PM, Lorenzo Stoakes (ARM) wrote:
>> > On Wed, Nov 11, 2026 at 12:55:12PM -0500, Tal Zussman wrote:
>> >> remove_migration_pte() makes the restored PTE writable for a writable
>> >> migration entry, and only looks at the uffd bit of the entry otherwise.
>> >> A writable migration entry that has the uffd bit set is therefore
>> >> restored as a writable PTE without the uffd bit, and the page is no
>> >> longer write-protected.
>> >
>> > The UFFD WP bit is such a terrible, invasive, broken piece
>> > of... engineering :)
>> >
>> > Notice, again, the hallmark of an utterly broken abstraction - every user
>> > just has to happen to know to handle each of your weird edge cases every
>> > single time they happen to interact with anything that touches it.
>> >
>> > I do hope we never merge something as bad as this again.
>> >
>> >>
>> >> An entry with the uffd bit set must be restored write-protected, whether
>> >> the entry is writable or not. remove_migration_pmd() gets this right: it
>> >
>> > Sigh :)
>> >
>> >> makes the PMD writable and sets the uffd bit as two independent steps,
>> >> and pmd_mkuffd() write-protects the result. To fix it, do the same at
>> >> the PTE level, where pte_mkuffd() write-protects the PTE as well.
>> >>
>> >> The only known path that created such entries is PAGEMAP_SCAN. Now that
>> >
>> > Wait what? :)
>> >
>> > How does a read-only scan of entries create softleaf entries?
>> >
>> > I think this should be explained in the commit message :)
>> >
>>
>> Will add a sentence... unfortunately not a read-only scan...
> 
> Thanks! Yeah I realised later the true horrors of what PAGEMAP_SCAN can do
> with uffd flags (ugh).
> 
>>
>> >> PAGEMAP_SCAN downgrades them like change_protection() does, we should no
>> >> longer see them, so this change alone should not be visible to
>> >> userspace. If another path ever creates a writable migration entry with
>> >> the uffd bit set, the page now stays write-protected instead of losing
>> >> the uffd bit.
>> >>
>> >> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
>> >
>> > This seems like a super-weird fixes target.
>> >
>>
>> So this piece of code was added in f45ec5ff16a7, but the issue derives
>> from PAGEMAP_SCAN, which is the commit above. I think 52526ca7fdb9 is
>> the right target, but can change it.
>>
>> > BTW I've noticed you've not been cc'ing stable, is that on purpose? No
>> > autosel in mm so we do need to do that on stuff intended to get backported.
>> > :)
>> >
>>
>> I added stable for patches 1 and 2, but for this one and the previous patch
>> the impact is PAGEMAP_SCAN reporting a page as written when it wasn't, which
>> over-reports but doesn't lose anything, so I left it off. Maybe I'm being
>> too conservative though.
> 
> No that's fine, if it's sensible not to then let's not.
> 
> Was just checking to make sure it was intentional ;)
> 

Looks like Breno hit the warning fixed by patch 3:

https://lore.kernel.org/linux-mm/avNEgmvYdoukt6MS@gmail.com/

So I think Cc stable it is.

>>
>> >> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> >
>> > The change itself seems reasonable, as cursed as the reason for it is, so
>> > with the fixes target confirmed + commit message updated:
>> >
>> > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> >
>> >> ---
>> >>  mm/migrate.c | 2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/mm/migrate.c b/mm/migrate.c
>> >> index 28a8d7734735..d200f64b5f98 100644
>> >> --- a/mm/migrate.c
>> >> +++ b/mm/migrate.c
>> >> @@ -399,7 +399,7 @@ static bool remove_migration_pte(struct folio *folio,
>> >>
>> >>  		if (softleaf_is_migration_write(entry))
>> >>  			pte = pte_mkwrite(pte, vma);
>> >> -		else if (pte_swp_uffd(old_pte))
>> >> +		if (pte_swp_uffd(old_pte))
>> >>  			pte = pte_mkuffd(pte);
>> >>
>> >>  		/* See do_swap_page(): restore PAGE_NONE for RWP */
>> >>
>> >> --
>> >> 2.39.5
>> >>
>> >
>> > --
>> > Cheers, Lorenzo
>> >
>>
> 
> --
> Cheers, Lorenzo
> 


