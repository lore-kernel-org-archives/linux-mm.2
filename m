Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057CB606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=V9FWSG7K;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=FhNMVdAr
Received: by kanga.kvack.org (Postfix)
	id 033776B05B1; Tue, 17 Nov 2026 10:28:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B3F6B05B2; Tue, 17 Nov 2026 10:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3C416B05B3; Tue, 17 Nov 2026 10:28:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3CF06B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:28:44 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18A221A04C5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:28:44 +0000 (UTC)
X-FDA: 85444993368.18.C290A6C
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf12.hostedemail.com (Postfix) with ESMTP id CF31140004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:28:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=V9FWSG7K;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="F hNMVdA";
	spf=pass (imf12.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794929322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6pyCr0GkLU3KUX4qf5YaMe8wc/vHjeUENbzf1v2mk8=;
	b=xZ8yU2+VcucoI76e+AW+C+NCowWYG6VIGj1x2IA0Yb0kmMFNJ7qLlJmcgXeaZl61HI8PFr
	hZ5Qoy+Fima7dlM87z6a8BR1SBz1lyftLgFR/VIwWFZpxhF4mtMODiV8PnS9xkaB7qQEIE
	shdAaoAZl+pKO1tshunfUYk+jG4FmyU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794929322;
	b=13RLU4+z5Xsk8u6Au6pf5rNeMXl7+Aa6DywmY3gmnYB95fExnbS2VaMl9KWmevmFgav0bE
	V5fr5mfSF9Din/d3CSeLF60WiYxdwmIjBrEEIbiqKedIPcouHxSXOPLd3e+jT5DhMK8i0V
	YzT5uxBM56ZSdNUamcJbcwqpZ9MmFaM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=V9FWSG7K;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="F hNMVdA";
	spf=pass (imf12.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 129D5EC060F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:28:40 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 17 Nov 2026 10:28:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794929317;
	 x=1795015717; bh=q6pyCr0GkLU3KUX4qf5YaMe8wc/vHjeUENbzf1v2mk8=; b=
	V9FWSG7KanChbguql1pGqVTYgsdbLO1OHzoGg0ROQEmhmowoYZ+lzYk6Zx1bt7bG
	Iho+o4laZKPQW3h1rWhM3pIH6rH0ZvmrIoC2Y5/HCY9vGTFzbZNz80Qv3tMWBYIj
	JBGNJTcGSDkvfRHl9P8w0lJl5DzKndXikm6/WeKukHUCIR3G+K9+d0dzGaL2GjbD
	t+thYQm2X2tNr0XRdaV/TJUEilGvRbUWBwfdiINMrFHKl0gc8swyHj1URI9LNFPb
	z9+bAbrIzt0u5YAROyv4ZzVXJ59yZD/PGt/4T8zyQbQdLiqPyDECLJX/M7vEiL/q
	DvqyjAdfFfBVxvwR5AXsVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794929317; x=
	1795015717; bh=q6pyCr0GkLU3KUX4qf5YaMe8wc/vHjeUENbzf1v2mk8=; b=F
	hNMVdArSi1j2Edq114cYAtkzv0SHGyv3MeNUEb/U86X44P1Fj0H0v2F8H0U0ZU5P
	ms1EpD/UugrFLJ1H53UIqNPPdBHzewSalQ9qNIInM/FppxMKUIw3Q/wQpotVwRd6
	UZ+iJUmDjmpj8DJ6WBNUkyPRaqnqEI1BOmfcKEIOZwoPrC+HFmqzOgBaPKWmc3lw
	PhRSfBGtV0lKOs9NzW/yJJ/IRQr0PDmomaIjCC+GlzLGRg+GetIv9tZjJsHDHEsV
	jX2Eui3Tgq4D3SmSIY7uE1AEIyOjap4iXi+SKJuF4dZW0VYUoP+V7mVcIwNbigD2
	2g6JScK2kv74Sa7NrqBiQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794929317; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:W+IoDqItF9vGUx//WwMRgMmLXD7K3iFId0+W+GtUndP9DlY
	5yrPSrePdQCdE8VfeoNZW3WpM8QTkvRCwA98ZOlyQNk+MK54MRs+rQszMbRJ0tnd
	IDRx9nkN+AVFrtbqiMcKPkS79wf7skdlfeJnENzDTpZJBC8TK6VFW9J/9T/akf8a
	xxwwT4A6677UJBVoM/+a8FTozpOqeRwVntf98CQMWvXLOJBAAPVj5o3Sxk75u+Bf
	CWS5F2UpqLoqwCL+7afoJYviMfdEZNssoWK3OPUNU8FtQfpMU0Xsh6C41wQzVlPM
	v8uGE/R5Xwnx/x/mr0i/dX0w9b+AYwodVdFA8gg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:wFlr+fT8EushZmCi/A62q7w2Btos2NKAwyaUzeqjiLk=:H9WGOLfPjUk/h+N3lN1a6Jp7duIUy/dutpF8qeTu8z8=;
X-ME-Sender: <xms:nXL8an35Jmtlsuk8surVwkqw1hxD9jGwHParnPrZczExG-fY4Jb-rA>
    <xme:nXL8ag5cieQ8MbNSxREODQc322J7zjuPLZbZK25MKuS3fZ3Zgq7ndYcdgebsGhQIg
    e7-f-h0PJLMyI2MOzAnDpIMtgQrXGAtKGqsJ5e_hyoGspiUe9kNVtHr3w>
X-ME-Proxy-Cause: dmFkZTGX7EIyx6vqTiIUSojs4OE9UyzzF5IPpKLC/H9pXDy5+hYRXbaHgdTstjLDjvMmhO
    qbAYAlIvMiVnHtDqch6S2ijYZkkekrM3/ArR9PA/spuF4E7hrOTr5s7AGdWBRYjLtYVhFZ
    A6zQUQvadLqOVzG5RPjUPTyokUGYMG5nIB5IQBmTJh8LLE8uIysOkjdAhH1cwXx4/lteMH
    Q2G/gqTAlRw03FumW41oadDeDqE8aeWzRuerjySLAFiGaMp3medyEgVUkw5HGWMwbFmRBC
    eP2NL21nvxUmL6fC11LJLiDrfUMdSDJs3PkUB6e4FL9JZsYANauAdJDIqVpCTNiqEsMQtX
    h+1us8HsYJJpAgERTWHljsadE0gqJ2WyPwytwdsRTlMRhKTZPOYPvzafDSIqFNbthNEhxJ
    y4hlVwbMMGI8OV34xeMlhhk6GSLEDjBsjLKXwjuplylLAT6rr7Sz/jWTtCC/JIsIhyWkHI
    gZiGDu4NpF0s4XpTimoCT315Qm421C4MTmCw8OKLinN99yTDsKqBMn20n//eM5906bj1IY
    JLzWlNh2TH2Hx+UcwJCmtbgasdyecTYy9XBgA86AFdUr72j5PcvFCMpDkiQDao/x8716ZX
    /fyUXSP6/otBnjqFgNqlWrtH8QfkIYXV6UQ9y4hHoGZaSMiNzPlLdPDuek2g
X-ME-Proxy: <xmx:n3L8anibFLfxet3kbA_7wgEMyzg7sa0frsq0EcErQF5egzbGaXUwgA>
    <xmx:oHL8aihAmrkaGYtvOzXx7l-iDJaePyEh76yA5xOTqDnSAu_qqbDTQg>
    <xmx:oHL8at5cLefG1GGlYhYLzqYMQa99S-3Dvib5WDe9xk4ejoT-mKnEgg>
    <xmx:oHL8akRKziG_meZAeRPYAezd2quBKbcNSaHu1TFvkPRBQhAYucwsGA>
    <xmx:pXL8aqta1EgWS4SY7AgRo9hTPnwfA2h8IKUvmRhEVacjyn1epzT-wpbL>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 2D8D432A0099; Tue, 17 Nov 2026 10:28:29 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AXxIX-uOARoc
Date: Tue, 17 Nov 2026 16:26:48 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Arnd Bergmann" <arnd@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Gregory Price" <gourry@gourry.net>,
 "Andrew Morton" <akpm@linux-foundation.org>, larips <larips950@gmail.com>,
 stable@vger.kernel.org, "Zi Yan" <ziy@nvidia.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Brendan Jackman" <brendan.jackman@linux.dev>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Jackie Liu" <liuyun01@kylinos.cn>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-Id: <541a67af-3b45-4d5d-ac4b-c741850f92e1@app.fastmail.com>
In-Reply-To: <avxnIQTcFni9G4IN@gremlin>
References: <20261117142628.3931151-1-arnd@kernel.org>
 <avxnIQTcFni9G4IN@gremlin>
Subject: Re: [PATCH] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ar3hf3wfo44k96yki3zw5pyutu3s679w
X-Rspam-User: 
X-Rspamd-Queue-Id: CF31140004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794929321-820299
X-HE-Meta: U2FsdGVkX19bPEontKw9vI3zt3FmocRnf+2EPoAFl9jB/EZmb7kduO207kF1HbD5bA6qG/DcPOUej2+dpEzdU2Q4aMgBGvPlf48fXzlew9HecLn+zZNRKnQ4o2hvjmngDtOoSGWmQVgD8SI43G6NAktcWpD6lIxc62i9TbI4MQNPp2e+MkmWxQSwcNLqJFejHR+VsoNBBjBn9GxsWo323TX7P/l+29VgXkSqdcYF7WzFpiE1cv86IN5BDFEqA45jnKDMKWOak7F/48oIKV7y+hNO5O83t6ybS8h3bdGJN2LRAysyDIohKbGrYUaW4Z0rghoFPJri40sH/tKnx+Mkp/VcrRbQVaevh6ymHqGDs7u32C/3C3TNdE4k/RBgeiMMdlDKJN3g1hNgRfLpO55eerD5iPLzxShMjcrEaogEJspUUoq2abwa8VTeurfs0S3OvgFRBzdlyCKD3aHkX+xzU/RyRI0F4l7JP3/P7oGYf56uHgSoo++wu016SkfyJk+S25Sm7vZd7if7hfNqkC2l8ZtP7ASQhZTdW4qzKB+ef50QdEQRH9bOHIKPWIS6dpM0tQsURIDgLHZr7lHt+tpqTWOw4SmLBtR78Aga2aM3GU8M42UhsnjAOr/d7FShnKm4dmrHNi4NxfxdQPNta+dS5M8cvMGRTdP5qhzuais6QEMqElFMvoelDAjPWSh82+scVwXDoZM8oR2KQndg25BtOUCPu7k0bJZPK3MzI42EuOOgLcnvvfXyq+jFbrCOvzKA+rbjPYyNYP4BX8D7ETZjEBYLeB7o5w1ZSwZSXM9LEHTsLZbFf9JJsY3RgH4vMyAiPM1dbKrGFR56HFj4d2HLJH+KpTwoZT4UWpmUWg7/fL4ovK6q/G1GdKh4zsKR4VNqsWek+kMAmQXf2LMs2I6+T97qY1SeLTNG60NLotNTHEYTFGsXQt7FOfpqC4YVU+g578hBn5oDQ/xGkJO7mQz
 TB54Vea1
 2WR5A0ykxN+yK8V2ZiubJ98cJuXExYXRsVQJFUTU4FITOjvE8tjRJ3DGv4Ul2nKvSNQQirBIlFOGoiUzH5shk3JRNufDxBHyFj0W/3bJN6Hdo94b2cFSXptgXIoK3jEP+IKRPm9+a3w4NF3mIQR7RR3GLbuIUFIqP567e95/b7lajTpb1h16PDwEdrVwLGPAMtfvrdua6jk0DxMBTOBxVWZ89UHvzjftEMN6iXh2i1B7R+X4aiA359uzUkudaIvgio0/ftoPL05OewzkkUB/qNDGGvG5bgIeV9umS5tZn22W7LuYZ+JQH9DRETzfJUzLNu1cGu1PV3eA2Cymf4c1ZDGwhjSLIqEDvw3YcswLZ/duwaQMbKJ3BsNEtkJLBNXCuZKP5/+i489PikyAl0ePJZ1RgJM8RSNlXusD20WJclHC/pYT0GMS82gzKXyW+XXhvVhYAVlS4uKktvHDKr7h5ZGN15A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026, at 15:59, Lorenzo Stoakes (ARM) wrote:
> On Tue, Nov 17, 2026 at 03:25:53PM +0100, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> For compat syscalls, the effect is worse, as the actual calculation f=
or
>> the size does include the extra word, but the check for the input size
>> does not take it into account and can leak a word of stack data.
>>
>> In addition, the size calculation rounds up to multiples of 64 bits
>> instead of multiples of word size as documented in the man page and
>> expected by numactl.
>>
>> Fortunately numactl always passes multiples of 64 here, so none of
>
> (Claude) went looking at numactl source (e.g. via libnuma) and it seem=
s it
> passes size + 1 matching the convention?

Ok, I see it now as well. The man page again says "maxnode specifies
the number of node IDs that can be stored into  nodemask=E2=80=94=E2=80=94=
that is,
the maximum node ID plus one.", which I'd na=C3=AFvely interpret as mean=
ing
that a system with 64 nodes would have a "maximum node ID" of 63 and
require passing one more (64), but clearly the implementation on
both sides expects a 65 here.

>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index 6d662a9a8c74..f318e1155770 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -1749,12 +1749,12 @@ static int get_nodes(nodemask_t *nodes, const=
 unsigned long __user *nmask,
>>  static int copy_nodes_to_user(unsigned long __user *mask, unsigned l=
ong maxnode,
>>  			      nodemask_t *nodes)
>>  {
>> -	unsigned long copy =3D ALIGN(maxnode-1, 64) / 8;
>> +	unsigned long copy =3D ALIGN(maxnode, BITS_PER_LONG) / 8;
>
> This looks like it'll be broken given the convention of passing bits +=
 1,
> e.g. ALIGN(1025, 64) / 8 !=3D ALIGN(1024, 64) / 8.
>
> Then later that could case a buffer overflow potentially?

Right, this would then overflow the user buffer.

> Overall it seems the issue is that e130242dc351 (understandably!) pass=
es maxnode
> rather than maxnode-1.
>
> So a really small fixup would be something like:
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index fb627b37afcb..051d411c04ee 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1733,12 +1733,12 @@ static int copy_nodes_to_user(unsigned long=20
> __user *mask, unsigned long maxnode,
>  		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
>  			return -EFAULT;
>  		copy =3D nbytes;
> -		maxnode =3D nr_node_ids;
> +		maxnode =3D nr_node_ids + 1;
>  	}
>
>  	if (compat)
>  		return compat_put_bitmap((compat_ulong_t __user *)mask,
> -					 nodes_addr(*nodes), maxnode);
> +					 nodes_addr(*nodes), maxnode - 1);
>
>  	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
>  }
>
> Maybe doing that's the easiest route for this?

I would still try to fix the other mistakes (aligning to 64 instead
of BITS_PER_LONG/BITS_PER_COMPAT_LONG and the incorrect nbytes).
Maybe it's clearer to just pass the adjusted maxnode into the
function directly and keep that extra '-1' in one place?

     Arnd

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6d662a9a8c74..931194421c4f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1749,12 +1749,12 @@ static int get_nodes(nodemask_t *nodes, const un=
signed long __user *nmask,
 static int copy_nodes_to_user(unsigned long __user *mask, unsigned long=
 maxnode,
 			      nodemask_t *nodes)
 {
-	unsigned long copy =3D ALIGN(maxnode-1, 64) / 8;
+	unsigned long copy =3D ALIGN(maxnode, BITS_PER_LONG) / 8;
 	unsigned int nbytes =3D BITS_TO_LONGS(nr_node_ids) * sizeof(long);
 	bool compat =3D in_compat_syscall();
=20
 	if (compat)
-		nbytes =3D BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
+		copy =3D ALIGN(maxnode, BITS_PER_COMPAT_LONG) / 8;
=20
 	if (copy > nbytes) {
 		if (copy > PAGE_SIZE)
@@ -2030,7 +2030,7 @@ static int kernel_get_mempolicy(int __user *policy,
 		return -EFAULT;
=20
 	if (nmask)
-		err =3D copy_nodes_to_user(nmask, maxnode, &nodes);
+		err =3D copy_nodes_to_user(nmask, maxnode-1, &nodes);
=20
 	return err;
 }

