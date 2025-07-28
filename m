Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00D2C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 19:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915A36B0089; Mon, 28 Jul 2025 15:29:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6166B008C; Mon, 28 Jul 2025 15:29:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5746B0092; Mon, 28 Jul 2025 15:29:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 697B26B0089
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:29:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1EBA12E2B7
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:29:55 +0000 (UTC)
X-FDA: 83714663550.21.61DA269
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf28.hostedemail.com (Postfix) with ESMTP id 94AEBC0007
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:29:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025072201 header.b=biJPsuNe;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753730994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qaSC4sqEzLaCELCha6qIBiTeeIabGiKR5v+0QyZ4F8s=;
	b=2GX+Dl4YtevlCMief4cLKQEv8XhDRCcdzVaFkIwk1cYyaOmD4iiCdbS25KnNaQxiH4FTB3
	Ll2HsfxqnTetfy5ruqgXcRryRmntsB6r8pmz6FJxIScNLC28ZIGEz36SH+LxC3DWLt8aRc
	HQ/SXJorAFyt4gWNIL8yFC20DSsnPdI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753730994; a=rsa-sha256;
	cv=none;
	b=42zlXgy+F4vVULMjLHMH/4MKcuJX61JtOdaKSAd3822uG/ZL5I9Qbn/w3tMnhxuIxIstkR
	IxM6esZzhf0tSUqeGfoOClqBh+zbFKxcIWnkKaXxLPxWR8nPlkiglvm4LDrpXORXbJlA2w
	6DC4uaXmGwb8mkdSRcmNfXSk2x08f8w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025072201 header.b=biJPsuNe;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56SJSYSu416102
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 28 Jul 2025 12:28:34 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56SJSYSu416102
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753730918;
	bh=qaSC4sqEzLaCELCha6qIBiTeeIabGiKR5v+0QyZ4F8s=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=biJPsuNeTxri3H9MoWJpmgZkkGQNuk21lGUNd/UGX0E+jkA7IRHGFfwvqnzYLgjyI
	 7IrpYPjZCNHFc5xhuao9cALcv4MeTy6uWXNU1I0k3t/294PzXyodbOHbGu2cA76VYo
	 TAxPmVGfVrjyntoadhsM8Di3RcccftzUDh7SYtUkXoOYlXT4076MMnuuTCePmG1Tqd
	 FZjJBQYK4/sS8CDtE3Qx7ADrtn5VrfwXWDV5MESUXcS0dk5cKyErIwQk/5eZz+uaQL
	 KERCz0I6QmZGsVz49Hz5YeDL3KDckKzAv8qlRwG6LKQ+w+MVo+7L25amYHBzmODrCi
	 cgqFA+v4RU8fg==
Date: Mon, 28 Jul 2025 12:28:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: David Laight <david.laight.linux@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Xiongwei Song <xiongwei.song@windriver.com>,
        Xin Li <xin3.li@intel.com>, "Mike Rapoport (IBM)" <rppt@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Michael Roth <michael.roth@amd.com>, Tony Luck <tony.luck@intel.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Sohil Mehta <sohil.mehta@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Kai Huang <kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>,
        Breno Leitao <leitao@debian.org>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Alexei Starovoitov <ast@kernel.org>, Hou Tao <houtao1@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Vegard Nossum <vegard.nossum@oracle.com>, Kees Cook <kees@kernel.org>,
        Eric Biggers <ebiggers@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>, Yuntao Wang <ytcoode@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Tejun Heo <tj@kernel.org>, Changbin Du <changbin.du@huawei.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-mm@kvack.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCHv9_02/16=5D_x86/alternatives=3A_Disa?=
 =?US-ASCII?Q?ble_LASS_when_patching_kernel_alternatives?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20250728201137.113d0f45@pumpkin>
References: <20250707080317.3791624-1-kirill.shutemov@linux.intel.com> <20250707080317.3791624-3-kirill.shutemov@linux.intel.com> <20250728201137.113d0f45@pumpkin>
Message-ID: <98BE7799-DA6C-4267-9E03-E6F68263D250@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s4hjptabk4ptx5by156p1bf617o6jxtz
X-Rspamd-Queue-Id: 94AEBC0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753730993-216965
X-HE-Meta: U2FsdGVkX19qRK07kl+r8G4D7mcbDpw3YziMUYy8nfGKWNNDqChYhwouacieYOBDzfPrDv6nzKHuhv77LYMPk4M4o9uX6V7XZaRa62A6JaiiqLGgBGqMOcmiOk4piN3Xom5UDnLZOO0R0a1hzKIh2K2a9nCWz1ZfODm/4R0gHTKssvpp+ibisuOsVSon2R8z0ePSX687WEEpcq3MLffBu8saCOrsVRBhVGA1/UeR/CmBkNh8m0OPO7vZYfstfAf35/4++vyM4Oiq8ycBFDu+rD9I3nL2m/9xK2Cp/hSFTkG2AvNLMP+HnK9m6rABadXLcaKnjmHQ9oCIGdCXeRN5FX/BIT/5VseRNGsCLQM/OMqSRsyeNR/3hjl4bDaFOU4XOTvi2gmeD+6shwUYwuiSqcm/wkDXD/stZTm/OuJE146635aQUI6/7vXTdX16El9WbAcFn//1C2XpCWYRNmxkys9UlqztRrCGnBof0Bfic2yqa1kzzYcGucVVR981oFO7cXtvlzp+c7CadTkVmrAUQFRkfEDVhT0trvIy+b6h6/iKazNfkhGVdRvMqLKB9bfKDbXDye0OPW1a2IfZ/o8IQeWfG2H8eBVxdiCrnWGnKweGNL3mw5wDL6j2KoUGeCYk6aONuNsF3SuhDwR5Ih/Ygp9MuVxPAcXAus474LURiBFfyfSIgVMjIw91wiT3M0rY5ebIgDeB9M052XRhUWBMghblDgtAHK5HF9Wx2NRU4UtB4CqFW4JzgBGmXS9rV4tIbaClU76mwVfkgZy9AbVqxfth0WH+8IpLSBZSr9gF0liNwdlYX9zlVN8T0CNtuvPX1c+Kmgo97gaev/CMvXwZgjP9/n/ZUbDS0slC9RRcV7a2ZVO3dn2QHdPhNKxptrZI967NDlZLV3yN6cHTNwayXj2enFvIXlZJeYbcJPiJDoYu4Tr+m8r+2ESHayY0wkt8i7vXEU8vka7+waeThx7
 8EyYT3e6
 KJdo6H6GoAJ6SAJvdJ7JjDTfWrvcHvjIdEQhw8Q4o20jinFRAYdgF4bk5XfpmsuKwlZ4rPmHQ3vG71oZzUFGvOIKebjQD1AqChQpvevs46+TCJMUwzMkg8EcPze5A+dVZDwvLAs4S8lKzmPgrjzS7tkr7FULSDLG7+gxARAfmvQSy2AFyMJG1/g32CDOQgKcGJ3+c6UHR7l1I6SUtxf9rwwbOUXykKlHZdKa4BT959be1UUwEW14Nh58tzVlXB0fO+Z3HU02FH/ZieUV5WzXQ0NVOJJ1762WGfENr9MbzxCfYITAggr9FDlKOvlDZuTXkp6eh+HdCdTzddQz+YywGPQofQZ/goCUhtDlfRr3MZLvBHJvli7M8Utwbt3CUnReCXBJ/6Fh6Aqnoo5Ax1VFf3Dw7HJu4Qr5VuFvLIKCWQVz3gTtJHG7hS48Uljvrt1hovsJEdkIrdjSVKKODReEmNwZbv7iG2HU/FyRe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On July 28, 2025 12:11:37 PM PDT, David Laight <david=2Elaight=2Elinux@gmai=
l=2Ecom> wrote:
>On Mon,  7 Jul 2025 11:03:02 +0300
>"Kirill A=2E Shutemov" <kirill=2Eshutemov@linux=2Eintel=2Ecom> wrote:
>
>> From: Sohil Mehta <sohil=2Emehta@intel=2Ecom>
>>=20
>> For patching, the kernel initializes a temporary mm area in the lower
>> half of the address range=2E See commit 4fc19708b165 ("x86/alternatives=
:
>> Initialize temporary mm for patching")=2E
>>=20
>> Disable LASS enforcement during patching to avoid triggering a #GP
>> fault=2E
>>=20
>> The objtool warns due to a call to a non-allowed function that exists
>> outside of the stac/clac guard, or references to any function with a
>> dynamic function pointer inside the guard=2E See the Objtool warnings
>> section #9 in the document tools/objtool/Documentation/objtool=2Etxt=2E
>>=20
>> Considering that patching is usually small, replace the memcpy() and
>> memset() functions in the text poking functions with their open coded
>> versions=2E
>=2E=2E=2E
>
>Or just write a byte copy loop in C with (eg) barrier() inside it
>to stop gcc converting it to memcpy()=2E
>
>	David

Great=2E It's rep movsb without any of the performance=2E

