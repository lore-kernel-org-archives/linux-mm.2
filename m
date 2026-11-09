Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F559606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W6MpHeay
Received: by kanga.kvack.org (Postfix)
	id 48F496B05B3; Sun,  8 Nov 2026 20:39:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F506B05B4; Sun,  8 Nov 2026 20:39:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356146B05B5; Sun,  8 Nov 2026 20:39:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 011926B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:39:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DB99C0529
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:39:53 +0000 (UTC)
X-FDA: 85413874266.17.A096E96
Received: from mta0.migadu.com (out-159.mta0.migadu.com [91.218.175.159])
	by imf03.hostedemail.com (Postfix) with ESMTP id 21E0720006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:39:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W6MpHeay;
	spf=pass (imf03.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.159 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794188391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2xK06hAlle1j90a3CpPJO7vvIwv6kxEANWMFayYuqs=;
	b=Qv79we7e+PDNjndXm4e5JHaAEyM7s0x4QDHX9F8ZhfJHi1AF5EWzMPVMnrLD7PoE05dFAp
	ZXgeQliPRhd9oN06rdfd10qkFHl0RuFNq9+kgqn3Cac6k2/GMVuUyN3TA33YjOTLw608JG
	K5/5ruWDEUVotKEkPZBhdhNAlN5PVT0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794188391;
	b=FTt3m/2dn1RvoNizrLKHBBZ19k+cvq12gaIlQd13na0lWG97LSA1M9l+B1oa8Ilv9Jd/11
	y7YJvV+OdCNsuYjYBopTPTJS+pv3OSxdfPcB6wJENTSrgWON9YTdIbAmED+j+6IYfvZSKb
	m/Sw9U8N1P2RMVECc7go6gB4FW3KRXM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W6MpHeay;
	spf=pass (imf03.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.159 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=e/0Al7Jq6L2SmlHKUg46RwY+VbHjriaoTpVNtLR0LwA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794188389; v=1; x=1794793189;
 b=W6MpHeayCZbzjlvQ0OSO4gVtStvURQRY2n5R2aLNua9loedlbM71B5O3kbUmU+kyDSu/YpNJ
 LuaF90vm8YbEGDtICzIfmmEGUyqz7sl9ZBPEw0Vw8fDrA8nAZnLHLFN9+H7A+6OS5kh0e/EVGcE
 j6VcxBpkRDEfzgA34mqRJ5As=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id f7a6dd49fc22b4a2;
	Mon, 09 Nov 2026 01:39:49 +0000
X-Mizu-Trace-ID: f7a6dd49fc22b4a2
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 09:39:39 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
	g@dgvxl46587.localhost.localdomain
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, Huan Yang <link@vivo.com>,
	Wang Xiao <xiao.wang@vivo.com>
Subject: Re: [PATCH resend] ksm: add merge_only_zero_pages to merge only
 empty anonymous pages
Message-ID: <avEkWyGoKsVlCCRG@dgvxl46587.localhost.localdomain>
References: <20261106034841.233085-1-xu.xin@linux.dev>
 <899b1b2b-4f6c-45e2-abd6-a333ac77b23b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <899b1b2b-4f6c-45e2-abd6-a333ac77b23b@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 8x8f83k4xnn1aap9rb3mfbs8en7q5zru
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 21E0720006
X-Rspam-User: 
X-HE-Tag: 1794188390-199292
X-HE-Meta: U2FsdGVkX1+3ZTI0BBuyVpdzorhv7BUn0/Ejuhi2v7CHLjQE5iKbT6WOR+K0X+SE2z2GXfXlcKq1XDrOlM6oCgYnG8w62epxOsaBZWi7OSosZBtENpF8SyMQgt+w5RfzCevKRaNYi/PkRYCfL4c/4psYZH7ERn81w2j1HxEpV3XDmc7qJIjXhvNRteTMmS1NtaHwmg2Nd4qaaRr1PgyPrsO3PYqrkfP+dQ0zFXUS5G4oXSl0JmREaY3V+TfmJ1Ae76fBSoWM36SOJUs2BJ3bayE0dQqoojviJEzFDCUBXfUIM77wFW+ueKVEKkYC+qxfNd17noV8u0AESZL5BXUvIYERYxxE3Be8m5zHySPJ/L8rohU6md1A6cvdkjqhXspXMoiBUr9TYR9NSOrkfHw0EClvXwaWi458nx3/ZTkm/XWrsMZNuCGPfYjeuqg9F2g+u5UpskVVpoqoWWtLoNXdWixKKikGepAJaW9obqSXrlwNzqztOvRXGU1PBug3ui7zx3eITELSRQHZsJ8yc3pChE3npM1vLrEbWdNFl4YDQvvxl8dmD1/BEgVkJ7nOhCrZ+mK1Q6pXA79c0RRR/fJ0c8EojCuwJazbjud01TcJr42EHjCLPNo5XbTL5YugIeZXwCmQz7uyZU8uv7XjrvEygsv6qUPs498KSDwOtubbpmya/swdirj+JiV76+gKeD8B6gTvdMGJoDAMrG53GyZhvskg3V4f20lZe46qcIRBHLUPeehJgbn1njjyjuXBamlB4za65zhoDRKmPiC7W/rvmez0rMcx4gGnFjRzheDBb6xy02mvy7lxgSpu+5Sgo1CQlL0KAa2WJb/WFG5llCZpz1t50DW4bIp/CVRlht9o1hG7WLELc5fTD24J4wGFsMVNvF9vJrYhyI8ZsOi2BykXOCt6OciTCUtQiQE6PM0NxQrh1rnhG0fbD+dphceNUSj+LUN29sJXKljqFcRh65j
 2ti5rcmJ
 sGQBkQIA9dIr35DrRsb14yQOsnI4infA73hNU3gjns9FWgHXPP6xghyLXNLKIuCy91FAO3CW8iGE/mSbs6Pnh1Yil6Psb0UBYQiBnB6w6lXI/iovq+Bb3ZH8ut3DgDMYawVKnTdbw+cic278cKhcQ8pYlq4v3OJ6CzDPVlgaH6b2+aCaMeBXfbJeNOrxVoGnXUzmylxgf30kVvBEjsCJcfBdjRPHnL+EuvtzbeOE9u1NV2Qnt1duILxCQHI76ZcLh04et7j599qxqxGYc9Eh+WE6DOAANRFCNZ2X+MMays/bO9YDzlwRSNDoJ7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 07:28:50PM +0100, David Hildenbrand (Arm) wrote:
> On 11/6/26 04:48, xu.xin@linux.dev wrote:
> > From: "Xu Xin (vivo)" <xu.xin@linux.dev>
> > 
> > Add a new sysfs attribute, /sys/kernel/mm/ksm/merge_only_zero_pages,
> > which, when enabled, makes ksmd merge only empty (zeroed) anonymous
> > pages with the kernel zero page and skip the stable and unstable trees
> > entirely for pages that carry data.
> > 
> > The attribute requires use_zero_pages to be 1, and the two are kept
> > consistent by symmetric constraints: it cannot be enabled while
> > use_zero_pages is 0 (-EINVAL), and use_zero_pages cannot be turned
> > off while it is active (-EBUSY). The new attribute can be changed at
> > any time and is only effective for pages merged after the change.
> > 
> > Benefits in three aspects
> > =========================
> > - Memory saving:
> >   On memory-constrained systems such as Android and embedded devices,
> >   zero-filled anonymous pages are the largest source of duplicate
> >   anonymous memory. They are produced by userspace allocators: the
> >   zeroing of freshly allocated Java objects and buffers in the ART heap
> >   (new byte[]/int[], Bitmap buffers), calloc/memset in native code, and
> >   preallocated media buffers. Merging them with the kernel zero page
> >   frees a significant amount of physical memory, which matters as DRAM
> >   costs keep rising. With this enabled, we measured 100MB–300MB saving
> >   tested with several popular applications on aarch64 (Android).
> > 
> > - CPU overhead reduction:
> >   Merging only zero pages also reduces the overhead of ksmd. A page that
> >   is not merged with the zero page carries data and can never be merged
> >   with the zero page, so there is no point in searching the stable tree
> >   or inserting it into the unstable tree for it. Skipping those tree
> >   operations for data-bearing pages reduces both the CPU time and the
> >   rhashtable memory footprint of ksmd, which makes zero page merging
> >   practical on low-resource devices where full KSM scanning would be too
> >   expensive.
> > 
> > - Security:
> >   Finally, this shrinks the KSM side-channel attack surface: only zero
> >   pages are ever merged, so the sharing status of data-bearing pages is
> >   no longer observable through KSM timing side channels.
> 
> Lol. Did you come up with that or an LLM :)

Ha, fair question :) This came from our own investigation. We were looking
into whether KSM can actually provide benefits on Android phones, and this
observation came from real-world application workloads. To be fully honest:
I did use an LLM to help polish the English wording of the commit description,
but I carefully rechecked and verified every sentence myself..

> 
> > 
> > Note
> > =====
> > - Suitable for Android, embedded and low-memory devices, where zero-page
> >   deduplication is wanted but full KSM scanning is too costly, and reduced
> >   KSM side-channel exposure is desired. Many handset vendors may prefer
> >   this knob, which can be used as a default fallback policy.
> > 
> > - Not suitable for server and virtualization workloads containing many
> >   non-zero duplicate pages, where vanilla KSM provides better memory
> >   savings.
> 
> I proposed something similar when I was still at RH. My concern back then was
> that we don't want/need all of the stable/unstable trees.
> 
> IIUC that's all still in place in your implementation, right?

We still keep the stable/unstable tree data structures, but zero-page merging
does not participate in the stable/unstable tree search path. One more reason
for keeping them is that merge_only_zero_page is designed as a dynamic knob
that can be toggled at runtime, so when it is disabled KSM can fall back to
the traditional full KSM behavior.

> 
> -- 
> Cheers,
> 
> David

