Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 444A4CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 05:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524606B0005; Thu, 28 May 2026 01:53:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D55A6B0088; Thu, 28 May 2026 01:53:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EBF46B008A; Thu, 28 May 2026 01:53:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31A736B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 01:53:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAEC3161E08
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:53:51 +0000 (UTC)
X-FDA: 84815762262.23.EEAEAF7
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id B82362000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:53:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lxIx6yZg;
	spf=pass (imf03.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779947630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVuZxbZ1lnRR8lzuxBuMksaeSxvcrcw4Tz1MmMLYI3w=;
	b=J0MVmYstD/iXwhr7/nf3t7GHZKLBQEZtKTZbmGCwRyeG/hMfQPexcbNvlmd35bFRNY8Z78
	Jdd7giklFYn6R17AleAXnUxxzqTL+ADPFwptYmizhP2TwZPXBno3Fgwf7zGFRFyIYSudIX
	OKXyYSIvya+tdf1PEXV+4be3Fr7TtAg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lxIx6yZg;
	spf=pass (imf03.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779947630; a=rsa-sha256;
	cv=none;
	b=6HzrnUTl/ao8zVmiDP1K0wTf4Fr/eSmPVUrqZbcErXcqwrIk4GyTPLTzg120IJVBWkAUBw
	m068uQ++1d0OnJPJ1re3Kmy/+Gge0ZwvaeNTdPXgUMDnXbGARsExsNy3T2kpNRiil79cy+
	OzonMiuo2dqwj4/15Mti4L1Bwb4h6SM=
Message-ID: <ac7a32d5-6c31-41a9-8a36-e64be12f45a3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779947627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kVuZxbZ1lnRR8lzuxBuMksaeSxvcrcw4Tz1MmMLYI3w=;
	b=lxIx6yZgNDE1g/MiMoDQTcoWhS8CYnrSEghVGdC+36zAtEGPxPH1MZaGs76OVkbUUZDjTb
	FIGLvs7dmM1CgKcJYeYS8uOvSNy4ArN+VAQ4RzrchbiVuca5jb7lWT1Q4MILgreOXXzBsp
	5ex0Zs8ZH30hUybzqd8YfKBI92jzd8s=
Date: Thu, 28 May 2026 13:53:25 +0800
MIME-Version: 1.0
Subject: Re: [RFC PATCH bpf-next v7 04/11] libbpf: introduce
 bpf_map__attach_struct_ops_opts()
Content-Language: en-US
To: Yonghong Song <yonghong.song@linux.dev>, Hui Zhu <hui.zhu@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 JP Kobryn <inwardvessel@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, KP Singh <kpsingh@kernel.org>,
 Tao Chen <chen.dylane@linux.dev>, Mykyta Yatsenko <yatsenko@meta.com>,
 Leon Hwang <leon.hwang@linux.dev>,
 Anton Protopopov <a.s.protopopov@gmail.com>, Amery Hung
 <ameryhung@gmail.com>, Tobias Klauser <tklauser@distanz.ch>,
 Eyal Birger <eyal.birger@gmail.com>, Rong Tao <rongtao@cestc.cn>,
 Hao Luo <haoluo@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Kees Cook <kees@kernel.org>, Tejun Heo <tj@kernel.org>,
 Jeff Xu <jeffxu@chromium.org>, mkoutny@suse.com,
 Jan Hendrik Farr <kernel@jfarr.cc>, Christian Brauner <brauner@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Brian Gerst <brgerst@gmail.com>,
 Masahiro Yamada <masahiroy@kernel.org>, Willem de Bruijn
 <willemb@google.com>, Jason Xing <kerneljasonxing@gmail.com>,
 Paul Chaignon <paul.chaignon@gmail.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Lance Yang <lance.yang@linux.dev>,
 Jiayuan Chen <jiayuan.chen@linux.dev>, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org, baohua@kernel.org
References: <cover.1779760876.git.zhuhui@kylinos.cn>
 <20bdaa33cc19364f5f10208c79ef94fe43bd5ac1.1779760876.git.zhuhui@kylinos.cn>
 <2fd62ec0-c594-4ac2-a95d-29eafbcb74d6@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <2fd62ec0-c594-4ac2-a95d-29eafbcb74d6@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B82362000C
X-Stat-Signature: 59ianny55mxsy7rmxochmwzohoemx5rg
X-HE-Tag: 1779947629-537893
X-HE-Meta: U2FsdGVkX1/wak/Rc4xPxIBEwN2QOX71wua2XG0Q97BP1+72ifrByhtYC/+ZbIzJhdWNsnxqWQ3MBOdP0s3G5uMzuQKYP5n7PP+sFmLBu+Lvbwvh4i0O/2R8lM3WQ0M6d1I3l1MxynzBjhsA87QNGPC0ZSb3OWUIQtI9Sz6gPJUBegShpHqARU9YuTEfZH4JSnl/S0/VuXqhqaAURibsWa2ISRRceiWoqPYquqTXJoG9GY1tpnZ4+zRKak4OFNIKJX2X/0zwvyfikBH6ptp4M7fKvsXDQgud40cgOUFe+HnKADCwZMfXbEl713VBENj0V18JzEOKelXhcAq0BKwwvavOXDcXmHcGImyH1QTPHjK5i+PYyBOMqC24t6L7RfJkroAWzKuytEtMGealyc07aHPqVWlxR+7FpKscLcUFrmW/ZQeh2loWxLnJ8ZNZOASYTsC/Ckizm9EQ9uZxMqQzQr5gNVPKH5Wo7XaB6Jd6ydtbTJIdR2aK0D7578wGWFJRcWFfveOsUEJ9u9boegOy236VQzreFLwNalwUeYIUF2LOgwPVqIunY3N0OnYxYOtQzRGGL/OdRoIagcvFe5TfZ4QY2ziCYCaB3G0qL4iai7i1VMhwkq7k4IyGlKaa14xS75y3GCgcElfmzaaiLY4vsSY8QSTMjZC4moODjEgTH6PGa/vyFfSQLR3BDXv4Cxhd22IvDFi5u0A8c7dxK56FslP22smbukBI53G0U1jKDzmsOKUspqBvLHqbXP2HpPXAqFMahBu1UAzycGdgtGbnTH7RmDxPdvZ+Xv+jNIErinXy34VIeZbh2957MdIaubmBLc8x9JK2yaorSLtJQe6MOCj0q9dd1LBBewt1Aw3TGDel8NJamxRSwepxci6fTB3WC63RekpLbzPjKtdTQ4e02kBLzYZwcJT2l47HI5SUJ5bNejV24hL59bAK2uQV0QPo6kJV6PTqvCJMxZ5Bpb2
 pIC274aF
 /i/EaDwEu/e8emq38Gaju6NAmI6dJ8pB1qJA0p3H0tj6cAEy+Oh2PsfIhWso2wld/UtLVLVKK1g/4bzSMWdEt8n6EwQ//BIfpLOs2UFQu+mHUG+FDKs6fo40IOPRZLkrNFiL8jRGgAfY0mIUhJynQ8tmG460Jxzx1JTQG3U4JD+5cMkIJjotzyTVmnATQzGA8MnA3p/6FWK28UxKasPgVSx+EbL2oceXDMTdHHXUBB7DLG0bdCyr7I17ACZX6K9XPvnvGwKOJeehXuj2QKrYU6U02UepgfqqLSmekq8AW++px7ZFdrKGDARit5G5UEBQlNh6ynawLgU/n6lHZxMNepmMccFbvfMNeaEcw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/5/26 23:43, Yonghong Song wrote:
> 
> 
> On 5/25/26 7:20 PM, Hui Zhu wrote:
>> From: Roman Gushchin <roman.gushchin@linux.dev>
[...]
>> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
>> index dfed8d60af05..6105619b5ecf 100644
>> --- a/tools/lib/bpf/libbpf.map
>> +++ b/tools/lib/bpf/libbpf.map
>> @@ -454,6 +454,7 @@ LIBBPF_1.7.0 {
>>           bpf_prog_assoc_struct_ops;
>>           bpf_program__assoc_struct_ops;
>>           btf__permute;
>> +        bpf_map__attach_struct_ops_opts;
> 
> Function bpf_map__attach_struct_ops_opts should be in
> LIBBPF_1.8.0.
> 

Pls also keep it in alphabet order.

Thanks,
Leon

>>   } LIBBPF_1.6.0;
>>     LIBBPF_1.8.0 {
> 
> 
> 


