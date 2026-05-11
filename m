Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B676DCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 10:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D906B00BF; Mon, 11 May 2026 06:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E776B00C3; Mon, 11 May 2026 06:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044956B00C5; Mon, 11 May 2026 06:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9E0D6B00BF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:40:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A0848D968
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:40:07 +0000 (UTC)
X-FDA: 84754794054.19.7E71C86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EB43A4000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:40:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p+noZOsu;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778496005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICyQxUgGMqrp8jj/BKUa7saTtN29G40EWzoTRiGMcUY=;
	b=CLTTJpXupBIQMXM+5vDLJOg4UUKxcRrVnlg+2+rLo6WRmi9jb65iZN9VHMyUTwuDDPdEUZ
	avsPUJnpCZ/SwGkJhuUhU5Z7dQkNgUR+Vjc++hjjlpGPTsle8VdbeGbt1exKo/2EuS3BPr
	O63OBPnJoJeiNgHnm7rFdYYaLL77I1w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p+noZOsu;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778496005; a=rsa-sha256;
	cv=none;
	b=F2pueSoSNjyvqTiMb85lfvja5L7XyxVnWjAF5FHYiu6dHDNTtGEqEq6WaEMcv4FyfCLAfj
	gifIl539jqvG9VAIVT574fspChoITEwM43JA+BKXDfoyADcyVSydUA3E0pdWkITqPxZuSg
	ORPQmi+EHlET8aN3oGDSLp4uP03TImA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 425756001A;
	Mon, 11 May 2026 10:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB439C2BCB0;
	Mon, 11 May 2026 10:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778496005;
	bh=ievUGX6a15St0U6OOTUzpHkIKC8RMvm95wgsajkWkZw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=p+noZOsuC5sYQvrwcooZNNLzThUrmYOT8CpZ/xRK9u3c5z9AxF3wqp/WZ0TswLAwX
	 06bog+cLW7O4d9b6FbB7XDmBc9DdGpLNrSGI7nYlGsgKn2Lkt9gcv9idfPzVDcuFkj
	 nXhbDgFuojCh1woDo7TPd2UG5zDxmK8KJSSuLdR3ojeXjnTBdkTXSOL70Mhzgh0H5n
	 iRK3emwYOsz9kSkoOiVuBoeMdodE3Iq+6IxjZedxUWsKiwQfF3F+2GLNtOx7xecwq8
	 t9EBH7l4q1v68zon1gqWQBoEBEHtKhFWK9uQktrOhNDoP2YVZB17IpSijsZRyaqzOI
	 1fqhXM3cCpqkQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  graf@amazon.com,  jasonmiu@google.com,  ran.xiaokai@zte.com.cn,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  George Guo
 <guodongtai@kylinos.cn>,  Kexin Liu <liukexin@kylinos.cn>
Subject: Re: [PATCH 1/1] kho: fix KHO_TREE_MAX_DEPTH for non-4KB page sizes
In-Reply-To: <20260509024415.33190-1-dongtai.guo@linux.dev> (George Guo's
	message of "Sat, 9 May 2026 10:44:15 +0800")
References: <20260509024415.33190-1-dongtai.guo@linux.dev>
Date: Mon, 11 May 2026 12:40:01 +0200
Message-ID: <2vxzcxz2dybi.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB43A4000C
X-Stat-Signature: gafaiibmqipjogjygmmmmfqxsu7j3cuo
X-HE-Tag: 1778496005-542732
X-HE-Meta: U2FsdGVkX1+WydutCMIZuND2wwg9phNDtM67Z/Dzgqiwa+wrp3WkMutYmH0J9X8KLjMF1rVgCjeG/ARJoOduirLUgHb2xKtR8SMjUE3aHzOgTYMJ/pH332TFLdAdCA+CYMSd/FAK1mRt8/iql1WjnnFhpVLAg0pxKv9LK23U4fh2R0UOAD17PoR1HOrMOemW5gwrLrPLxc/aWJXFCAZv7Z5bn9fZ6/ZByG/0YWpHcs1ZKZ8HmafcL/RuUATyE9TANvR9BL9iq6bkM+JJVOLQ8vkP/HNDMlzN9kRCh8zdu1vwAKhr3T94afsg5yfezrndJxAwVlhI2MlM0n67FICYshvh/B3R4NQy1BBcASyy3jOcfb3I1fpi3CIYscf5o2anK+E48tXJ1MgAkokG0XuWMORW7+oaMYmtG5TKzTIpY0cRcHzRA1Z9KujNKklrVBUxF+u1mzSoqAZTUNiRS5mGjtb/1leQVT0Ta1mbC0ZIKg4nwKS2h2NuUhkpuxjSz12pKTvFxs9fNRtCORgLVsibQ/m+HDmvY1mAB+KyUb0mcp84wk7BAtN+pmzCx1b+2Nzu6k7Dq0WnHi1046La5pXLrJPaCtZnADqt971pAq+T8HmkSutO/e99/irVKNUBZO4baiQDLrzKZAVJH4Q0NBx3mzah9NMPGbNEAy6CJDBBsTp0askLMEOAGa7N1lkrSIf1kC+u8qIiVf8EeNUmh3IZgwvTUr/YCMMJSgCSB6QUvr7W8KyZR6g75ET0WfCkatssOtgiMi1miUcJDkyNfCl4gcdsr56vXgyaPlB94IL5VIOwbZ6+CT4IvMbyDQ5DqOs1jW64B9nsVoCaQswccoY1De4u+HewPjVE9WM8xIUkwTqwvTCZBgHexx4U5VIaq7KXcRzN06hg0LL6zY+vWNJ2rX8qijnnQtCzWbrnwJ7ASQixJc8o+RJ2ceSolm4uibPAEyF8ZBITTI09Qadz0+C
 H9vRd+Qg
 c4RpuOaDsyREk64g/0gt5tlKGdRKH10VYVjs0MjdCAdt1VG54k0v3Y1wcPZTYlnusx/wYgNByoSmkckYCgtBvOvxDkvNPhrkVJJ8acu23NjXa77iYgeqN4PLX57OgPxNznciAQnouHEieW9YZ5AEYg4LeDZeHSRyPzI8k94v3s5uPSntyOsL28ex4Tvs44JHRrDkbZ+loIYhixlqpbAnCa5G1dfrjXTQBlQ6SQfzZ387HybOxn+LMgHNkKSEsCrEx/tKdjhmw2T+OxOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 09 2026, George Guo wrote:

> From: George Guo <guodongtai@kylinos.cn>
>
> KHO_TREE_MAX_DEPTH is calculated as:
>
>   DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2,
>                KHO_TABLE_SIZE_LOG2) + 1
>
> For systems with 16KB pages (e.g. LoongArch), this gives a depth of 4,

As of now, we only support KHO on x86 and arm64. Support for other
architectures is not there. Are you working on supporting it for
LoongArch? What is your use case?

Without LoongArch supporting KHO, this remains a purely theoretical fix.

> with the top-level shift at bit 39.  The order-0 bit sits at bit 50
> (KHO_ORDER_0_LOG2 =3D 64 - PAGE_SHIFT =3D 50).  When inserting or reading
> a key, the index extracted at the top level is:
>
>   (1 << 50) >> 39 =3D 2048
>
> 2048 is exactly the table size (PAGE_SIZE / sizeof(phys_addr_t) =3D 2048
> for 16KB pages), so it wraps to 0, aliasing the order bit to index 0
> and losing it silently.
>
> On the second kernel, kho_radix_decode_key() sees a key without the
> order bit, calls fls64() on the wrong bit, computes a wrong order and
> thus a garbage physical address. phys_to_page() of that address faults
> in kho_preserved_memory_reserve(), causing a kernel panic early in boot.
>
> Fix by adding +1 to the DIV_ROUND_UP numerator so the formula accounts
> for the order bit itself, giving depth 5 for 16KB pages. The top-level
> shift becomes 50, and (1 << 50) >> 50 =3D 1, which is nonzero and
> unambiguous. For 4KB and 64KB page sizes the depth is unchanged.

Maybe I don't understand the math so well, but I can't see the problem.
Here's what I did in my calculator (the lines starting with the =3D are
the result of the previous statement):

First, define all the constants:

    PAGE_SHIFT =3D 14
    =3D 14

    KHO_ORDER_0_LOG2 =3D 64 =E2=88=92 PAGE_SHIFT
    =3D 50

    KHO_TABLE_SIZE_LOG2  =3D log(2; (1 << PAGE_SHIFT) / 8)
    =3D 11

    KHO_BITMAP_SIZE_LOG2 =3D PAGE_SHIFT + 3
    =3D 17

    KHO_TREE_MAX_DEPTH =3D ((KHO_ORDER_0_LOG2 =E2=88=92 KHO_BITMAP_SIZE_LOG=
2) / KHO_TABLE_SIZE_LOG2) + 1
    =3D 4

Then let's assume the highest possible physical address (52-bit
addressing) and order 0:

    phys =3D 0xffffffffff000
    =3D 4503599627366400

    order =3D 0
    =3D 0

This makes the key:

    key =3D (1 << (KHO_ORDER_0_LOG2 =E2=88=92 order)) | (phys >> (PAGE_SHIF=
T + order))
    =3D 1126174784749567

For higher orders the numerical value of the key will be smaller so this
is the highest possible key.

Then do what kho_radix_get_table_index() does to get the index on level
4:

    level =3D 4
    =3D 4

    s =3D ((level =E2=88=92 1) =C3=97 KHO_TABLE_SIZE_LOG2) + KHO_BITMAP_SIZ=
E_LOG2
    =3D 50

    idx =3D mod((key >> s); (1 << KHO_TABLE_SIZE_LOG2))
    =3D 1

If we do get a 5th level, the index would be:

    level =3D 5
    =3D 5

    s =3D ((level =E2=88=92 1) =C3=97 KHO_TABLE_SIZE_LOG2) + KHO_BITMAP_SIZ=
E_LOG2
    =3D 61

    idx =3D mod((key >> s); (1 << KHO_TABLE_SIZE_LOG2))
    =3D 0

So based on this, looks to me that the 5th level table won't ever go
above index 0 and the 4th level is enough to represent all possible
keys.

What am I missing?

Also, Jason, can you please help review this? You understand the math of
the radix tree the best I reckon.

>
> Fixes: 3f2ad90060f6 ("kho: adopt radix tree for preserved memory tracking=
")
>
> Tested-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  include/linux/kho/abi/kexec_handover.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/a=
bi/kexec_handover.h
> index 7e847a2339b0..db9bda6dd310 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -274,7 +274,7 @@ enum kho_radix_consts {
>  	 * and 1 bitmap level.
>  	 */
>  	KHO_TREE_MAX_DEPTH =3D
> -		DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2,
> +		DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2 + 1,
>  			     KHO_TABLE_SIZE_LOG2) + 1,
>  };

--=20
Regards,
Pratyush Yadav

