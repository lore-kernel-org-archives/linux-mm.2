Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB69606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 11:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=RutNwzDB
Received: by kanga.kvack.org (Postfix)
	id 848EA6B05B6; Thu, 29 Oct 2026 07:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC056B05B7; Thu, 29 Oct 2026 07:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C526B05B8; Thu, 29 Oct 2026 07:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 393796B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:40:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF624140374
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:40:40 +0000 (UTC)
X-FDA: 85375471440.09.6F6D119
Received: from cu-gy11p00im-quki08141502.gy.silu.net (cu-gy11p00im-quki08141502.gy.silu.net [157.255.1.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4EFA1180008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:40:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=RutNwzDB;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf24.hostedemail.com: domain of bfguo@icloud.com designates 157.255.1.69 as permitted sender) smtp.mailfrom=bfguo@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793274038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KZF1/s0C4sZeNgdAZHGjDdjaxfKkMFHjY6N3yQSkxg=;
	b=vz5x0keFiu1eWDRLLwT3KO8rSRwqaxFlAfZq2gD9fzENQDhp09UjUKwOQc4OKE31AsDjks
	pUkBKojKHMIPTojUoxyGpiDtWlo/CP3zevEQj96tnWpzaJrCY9L0Os/MvP3KN5kjmyInX5
	EEJDj6rJx6z1GZwhOnwJaRmbbYsY5JQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=RutNwzDB;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf24.hostedemail.com: domain of bfguo@icloud.com designates 157.255.1.69 as permitted sender) smtp.mailfrom=bfguo@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793274038;
	b=FOM9lY90C1oWjxGpBDzZqWE61a55D6r3wVpd2FX0RWy0jjm1DYZ84DkEQQnnM7mIm5PClm
	MVmzZRa37DaSY26CNHiAoxTQDfnSmTRJrHNyr1BAH6Q/HESgOmvWSJAll3LWx/p5CjC8Kd
	8yytsbNnsT/456K71YxonMEjWOyPi+k=
Received: from smtpclient.apple (gy11p00im-asmtpcmvip.gy.silu.net [112.19.199.76])
	by gy11p00im-quki08141502.gy.silu.net (Postfix) with ESMTPSA id 5EBC93520088;
	Thu, 29 Oct 2026 11:40:22 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1793274032; x=1795866032; bh=2KZF1/s0C4sZeNgdAZHGjDdjaxfKkMFHjY6N3yQSkxg=; h=From:Message-Id:Content-Type:Mime-Version:Subject:Date:To:x-icloud-hme; b=RutNwzDBtbRqlJgkxDe6zicuH3qIautgrTYQObme3hY9jY/G6iuVPsodoIyFGqgWFf3HTJsitqanPqmgJbg2b/cM8OcXiNzJkhd8IHeQ1acg22Wzl7VEkrwst3ha4qS9LnI1HM5jzBO2WE/lvceXwY92OG+11enc1VwRk+coSi4KH3lFdANXlieGMLhfTyGiGtQeDUfulRR6qsImLDJYumZFHLVdwh+Hz2AQk6KsAEU9WmasDEYpozEfimqI/X//Heqt7qzBrj6bwbA4MX99s53w9xkvMHoEgtJ9RDf4I3cSNKFwTN2+1i3PegpGlYru+NGgbSDFYZoaqKZL8M+qxA==
From: Bingfang Guo <bfguo@icloud.com>
Message-Id: <82AED38D-3084-4B8F-BD86-859FF41D3213@icloud.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_3726A5FE-45B5-46FC-9A24-E3F1D05B3923"
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH] mm/mglru: skip oom killing for high order allocs in
 kswapd
Date: Thu, 29 Oct 2026 19:40:10 +0800
In-Reply-To: <CAMgjq7CcSxNMx9UxVjjM=W11fhd8sh3PgkHKt2kvdah3fy6kXg@mail.gmail.com>
Cc: bingfangguo@tencent.com,
 Andrew Morton <akpm@linux-foundation.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Yu Zhao <yuzhao@google.com>,
 Bingfang Guo <bfguo@icloud.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
To: Kairui Song <ryncsn@gmail.com>
References: <20261027-fix-mglru-kswapd-age-v1-1-b1ffdec4ae52@tencent.com>
 <CAMgjq7CcSxNMx9UxVjjM=W11fhd8sh3PgkHKt2kvdah3fy6kXg@mail.gmail.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Proofpoint-ORIG-GUID: xAlX13lwV_7G2SoviTYYwgDhIBF53CBJ
X-Proofpoint-GUID: xAlX13lwV_7G2SoviTYYwgDhIBF53CBJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA0MyBTYWx0ZWRfX8JcoWYcBuK7a
 GQqFLMkIEAh7Zxd3zjBFL+/zezxEnJ3rBAX8RDQsBEZkE2vsLY9jd8rVLG0LNxMV+POHFT08LDX
 X6FVDP9WcfyujlHnjKNRDk5Axagt5rkZg7G3BnqW5yBa7SWWhZDht/oy7IK5Lhuj1+t4y0mJ/A2
 nt/tnG9jRCxmF5e3ixlr63fXJM29zfdieH0xwPgpMuNxc+q42l8xnLVjb8nk9otFjccFFWEDnAu
 eUhsYrJqBqXTVZe7nSCE8yqy2GgDoIFEK4SA3CeN7ADuickAPzJEfYw8JWnDBIdwxr6A8nnnrtL
 kc+xXkr3mFxvSUGWcGLWo8LWUxddIWSmx5Fa/KGiw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=-2147483648 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2610290043
X-Rspamd-Queue-Id: 4EFA1180008
X-Stat-Signature: eot9ao8t3nbwmbs45ae5c1wee98rumz3
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793274038-622894
X-HE-Meta: U2FsdGVkX1/BnRMlc6Z2zTeMN0jwxw3Q9+iV5hh7kMfjQ4iJdQ8lFPpILZ3ix9DIAQzqP1muP0VcjO2iXwegHPFT/J23QIW2eARAQVw//9XV1eBIF6MoBwdRpPwp6npqBh9toPXifXw7u8d1RF4gEaHWQKqAtZ/Af+s5iHDRpmyBAn0G7fOT2145nwW+/Xo2ZoD0LQ4OI+AU3D7urAO7wLTCpIh+caxFRXf+d/yhna0Stjjjeiix7hS+vql1PccCcBJn9ibj4ZOy7lzcgYvv3Yw7rhKmDnzG4rcBHn7m7VFPlv4PsQSD48yfouje1UTAU+scMysF9kzA31OqqNg7SkCzwjDz5GZaz0bxbX63dHthhztyZxhRemKgJWdkiTrQnPeNL7eVBrTNGlO8rdQgK8pfVAvPxObSjDYWlTFPXpQvSN3w47KSfvE0rd4879OhbRVFM41Q5Ij7VTGZ4fyB0bybAx6BpEUZgUF7YgnkoVpGHe8D9xxdDv1y1ybDUNWtvBavaF6zPB4I601kc/m+Y7GY4qRjFM3fkLOAmRCWhKwVWfEQWvwKnBClBhElOtDZ3qp9EYVlxWc219IsuXD/xBb1+k4dulpNEUzj4jlY/0FnG2/v+okv0OLBE+4muEPJveG2CV23YGt78Ly52bmyLtuJ70MZCSjs67RVRmSgttp87S4vXbd5FIH5DLJSYcuIgctyNqM3ESvQpJs0LaEtMSx/w/UIpaEoxglNtDFUFoTyohFcIu8XULgYvLoTfMvckr5++4YwyQya8pMFw4fjrH4ePNzAxpuc3dB62kpw4862SknoblH/Ohv8rz2LLdnUgRyZ7yWgKuX8IBXHnfnE7nmdMeUGe1f6pY9sRyeTWx2NCYoxT5YHAOjS1hGMIvBermvLpBfNNPsf/5U8MJOgX6KT8JJkk+/AGdmxAxayjc3b+VaE2r5gjPIztTSk0VuxxvVJQSjNwPG3cBTFg9w
 j9qxCvbN
 1Fw5TSoyvUcLiNFEJK8L+qCyEW0v9yzUktlF2PSpvxgXe74pJzkVw/xROeB2hrdbFY/kWLvoCwCsEEfzbsWo7Bvfq8/zHEdOn7LH4gLRdz4VJKnCbWsV2OKZRJMMbZT4Q/TCp7q+4bmP30gJ3r4PqTZmhyMWNROVxcPD4PoQ8agN6KUA0Vmo1yc9/TSN0TpqE6L+NeRcXtnyGsF56ImDjOAMj090vU9s0LktaIuZO6COU3lSMrQ5pzl0+DEWQpTY7jQLS1aeo93M0DPSJcAb2PsIgdZEiKbhepeCgn+5b7ekYIgn08vV3S07FwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Apple-Mail=_3726A5FE-45B5-46FC-9A24-E3F1D05B3923
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Wed, Oct 28, 2026 at 09:56:48PM +0800, Kairui Song wrote:
> On Tue, Oct 27, 2026 at 10:21=E2=80=AFAM Bingfang Guo via B4 Relay
> <devnull+bingfangguo.tencent.com@kernel.org> wrote:
>>=20
>> From: Bingfang Guo <bingfangguo@tencent.com>
>>=20
>> We observed that when MGLRU min_ttl is set and the system is highly
>> fragmented, high order allocations (e.g. order =3D=3D 9) will fail =
and wake
>> up kswapd. It can not make any progress, while pushing generations of
>> memcgs so that they all end up younger than min_ttl_ms, repeatedly
>> triggering the OOM killer in lru_gen_age_node(). Then the whole =
process
>> repeats until all processes are killed and the kernel panics.
>>=20
>> Fix this by skipping OOM killer invocations in lru_gen_age_node() for
>> sc->order > PAGE_ALLOC_COSTLY_ORDER, which is also what the normal
>> allocation path will do, to fail high order allocations without OOM
>> killing.
>>=20
>> =3D=3D=3D=3D Testing =3D=3D=3D=3D
>>=20
>> Tested on a VM with 6 cores and 6GiB of memory, HZ=3D1000, MGLRU =
enabled,
>> min_ttl_ms set to 1000, and a workload that fragments the memory then
>> allocates 2M pages.
>>=20
>> Without the patch, kswapd kills all processes and panics the system =
even
>> with plenty of memory available. With the patch, allocations fail but
>> the system remains stable.
>>=20
>> Fixes: 30d77b7eef019 ("mm/mglru: fix ineffective protection =
calculation")
>> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
>> ---
>> mm/vmscan.c | 6 ++++++
>> 1 file changed, 6 insertions(+)
>=20
> Thanks! Really nice catch.
>=20

Thanks for reviewing, Kairui!

>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 9959ca158ce83..b32777468ead8 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4407,6 +4407,12 @@ static void lru_gen_age_node(struct =
pglist_data *pgdat, struct scan_control *sc)
>>                        reclaimable =3D lruvec_is_reclaimable(lruvec, =
sc, min_ttl);
>>        } while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)));
>>=20
>> +       /*
>> +        * OOM killing won't help high order allocations. Skip and =
let them fail.
>=20
> A nit pick, OOM definately helps for high order allocations :-D, maybe
> something like, the OOM kill is to prevent thrashing whtn all memcgs
> are younger than min_ttl (and maybe merge with the comment & check
> below?), so OOM for fragmentation is definitely unwanted.
>=20

Right. OOM might help but not in this case. And that sounds make much =
more
sense. I'll update it!

>> +        */
>> +       if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
>> +               return;
>> +
>>        /*
>>         * The main goal is to OOM kill if every generation from all =
memcgs is
>>         * younger than min_ttl. However, another possibility is all =
memcgs are
>=20
> This patch is good to me on its own with a nit fix above.
>=20
> And checking commit 30d77b7eef019, you might need a Fixes: or maybe
> even bring the check back which was removed in that commit?
>=20

And after reading reviews from sashiko, I think I can just restore the =
original
check. Use:

   bool reclaimable =3D !min_ttl || sc->order || sc->priority !=3D =
DEF_PRIORITY;

This prevents unexpected OOMs for 1..3 order allocs in some case as =
well,
although they should be rare based on my tests. And this removes =
redundant check
runs for every memcg in this case.

> But for long term, and as a follow up, the whole idea of OOM in kswapd
> seems kind of wrong, maybe at least it need to check the water mark
> here?
>=20
>=20

Agreed. And as you mentioned above, OOMs are not expected by =
fragmentation. So
it's best to have some ways to distinguish very young generations caused =
by
thrashing from something else.


--
Thanks,
Bingfang=

--Apple-Mail=_3726A5FE-45B5-46FC-9A24-E3F1D05B3923
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta charset=3D"UTF-8"><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dutf-8"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><span style=3D"caret-color: rgb(0, 0, =
0); color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; display: inline =
!important; float: none;">On Wed, Oct 28, 2026 at 09:56:48PM +0800, =
Kairui Song wrote:</span><br style=3D"caret-color: rgb(0, 0, 0); color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: solid;">On =
Tue, Oct 27, 2026 at 10:21=E2=80=AFAM Bingfang Guo via B4 =
Relay<br>&lt;devnull+bingfangguo.tencent.com@kernel.org&gt; =
wrote:<br><blockquote type=3D"cite"><br>From: Bingfang Guo =
&lt;bingfangguo@tencent.com&gt;<br><br>We observed that when MGLRU =
min_ttl is set and the system is highly<br>fragmented, high order =
allocations (e.g. order =3D=3D 9) will fail and wake<br>up kswapd. It =
can not make any progress, while pushing generations of<br>memcgs so =
that they all end up younger than min_ttl_ms, repeatedly<br>triggering =
the OOM killer in lru_gen_age_node(). Then the whole process<br>repeats =
until all processes are killed and the kernel panics.<br><br>Fix this by =
skipping OOM killer invocations in lru_gen_age_node() =
for<br>sc-&gt;order &gt; PAGE_ALLOC_COSTLY_ORDER, which is also what the =
normal<br>allocation path will do, to fail high order allocations =
without OOM<br>killing.<br><br>=3D=3D=3D=3D Testing =3D=3D=3D=3D<br><br>Te=
sted on a VM with 6 cores and 6GiB of memory, HZ=3D1000, MGLRU =
enabled,<br>min_ttl_ms set to 1000, and a workload that fragments the =
memory then<br>allocates 2M pages.<br><br>Without the patch, kswapd =
kills all processes and panics the system even<br>with plenty of memory =
available. With the patch, allocations fail but<br>the system remains =
stable.<br><br>Fixes: 30d77b7eef019 ("mm/mglru: fix ineffective =
protection calculation")<br>Signed-off-by: Bingfang Guo =
&lt;bingfangguo@tencent.com&gt;<br>---<br>mm/vmscan.c | 6 ++++++<br>1 =
file changed, 6 insertions(+)<br></blockquote><br>Thanks! Really nice =
catch.<br><br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: none;">Thanks =
for reviewing, Kairui!</span><br style=3D"caret-color: rgb(0, 0, 0); =
color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite">diff --git a/mm/vmscan.c =
b/mm/vmscan.c<br>index 9959ca158ce83..b32777468ead8 100644<br>--- =
a/mm/vmscan.c<br>+++ b/mm/vmscan.c<br>@@ -4407,6 +4407,12 @@ static void =
lru_gen_age_node(struct pglist_data *pgdat, struct scan_control =
*sc)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;re=
claimable =3D lruvec_is_reclaimable(lruvec, sc, =
min_ttl);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;} while ((memcg =3D=
 mem_cgroup_iter(NULL, memcg, NULL)));<br><br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/*<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* OOM killing won't help high =
order allocations. Skip and let them fail.<br></blockquote><br>A nit =
pick, OOM definately helps for high order allocations :-D, =
maybe<br>something like, the OOM kill is to prevent thrashing whtn all =
memcgs<br>are younger than min_ttl (and maybe merge with the comment =
&amp; check<br>below?), so OOM for fragmentation is definitely =
unwanted.<br><br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: none;">Right. =
OOM might help but not in this case. And that sounds make much =
more</span><br style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: none;">sense. =
I'll update it!</span><br style=3D"caret-color: rgb(0, 0, 0); color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite">+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (sc-&gt;order &gt; =
PAGE_ALLOC_COSTLY_ORDER)<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;return;<br>+<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/*<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* The main goal is to =
OOM kill if every generation from all memcgs =
is<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* younger than =
min_ttl. However, another possibility is all memcgs =
are<br></blockquote><br>This patch is good to me on its own with a nit =
fix above.<br><br>And checking commit 30d77b7eef019, you might need a =
Fixes: or maybe<br>even bring the check back which was removed in that =
commit?<br><br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: none;">And =
after reading reviews from sashiko, I think I can just restore the =
original</span><br style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: none;">check. =
Use:</span><br style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><span style=3D"caret-color: rgb(0, 0, 0); =
color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; display: inline =
!important; float: none;">&nbsp;&nbsp;&nbsp;bool reclaimable =3D =
!min_ttl || sc-&gt;order || sc-&gt;priority !=3D DEF_PRIORITY;</span><br =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><br style=3D"caret-color: rgb(0, 0, 0); =
color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: none;">This =
prevents unexpected OOMs for 1..3 order allocs in some case as =
well,</span><br style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: =
none;">although they should be rare based on my tests. And this removes =
redundant check</span><br style=3D"caret-color: rgb(0, 0, 0); color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: none;">runs =
for every memcg in this case.</span><br style=3D"caret-color: rgb(0, 0, =
0); color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;">But for =
long term, and as a follow up, the whole idea of OOM in kswapd<br>seems =
kind of wrong, maybe at least it need to check the water =
mark<br>here?<br><br><br></blockquote><br style=3D"caret-color: rgb(0, =
0, 0); color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: none;">Agreed. =
And as you mentioned above, OOMs are not expected by fragmentation. =
So</span><br style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: none;">it's =
best to have some ways to distinguish very young generations caused =
by</span><br style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: =
none;">thrashing from something else.</span><br style=3D"caret-color: =
rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><br style=3D"caret-color: rgb(0, 0, 0); =
color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: =
none;">--</span><br style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: =
none;">Thanks,</span><br style=3D"caret-color: rgb(0, 0, 0); color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; display: inline !important; float: =
none;">Bingfang</span></body></html>=

--Apple-Mail=_3726A5FE-45B5-46FC-9A24-E3F1D05B3923--

