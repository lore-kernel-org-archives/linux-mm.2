Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C9F8606A687
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 21:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hRXebOuc
Received: by kanga.kvack.org (Postfix)
	id 5A78E6B05B1; Fri, 27 Nov 2026 16:21:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5598E6B05B5; Fri, 27 Nov 2026 16:21:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D9D6B05B6; Fri, 27 Nov 2026 16:21:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 217A86B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 16:21:53 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9772B1C3CBE
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:21:52 +0000 (UTC)
X-FDA: 85482171264.06.C841504
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id E599BA000B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:21:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hRXebOuc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795814511;
	b=VkkdmYa18Yq5TOQqqYx8Z/jQrEaBCt3RtO6vOcP2XVGC7QllaMGAkEF9fcF8injaM2XXws
	jXz2l+N1K5Wyr02fLUvAJfUS52jcH5fNgCM17TjzQQV5rp9JAVQu5YYLE66lSCBE3MjZLV
	k3CpeQt5F0eHwXq24YZKKw5JCr9qHwA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795814511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wctQaa4+oug07SAylojzJ054zlJWMzb1RewZ5KzRtMM=;
	b=1zBjiczS2sEJ3bfLYBvRAlHlKHnBfgXI1PdA+TCKw4eG4wPUd3lcFYOYjPyagF5Cvx7zuI
	EFnsh8qKPQmJGtAggNjBJx4z++HEi80FWv/m2ak/VwrG8YwM0b1QzXY2XapO6Np8ghiaXw
	40WY4sFpW19HWaSQW342F2xVfH1WUMM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hRXebOuc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 708F561239;
	Fri, 27 Nov 2026 21:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C866E1F000C1;
	Fri, 27 Nov 2026 21:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795814510;
	bh=wctQaa4+oug07SAylojzJ054zlJWMzb1RewZ5KzRtMM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hRXebOucKI08nPo50le2NMBN0BGP0AOzDoAaNNdAVq/25QRPg/rw23aHbEoViCREm
	 /NZCQ3uhllGjJK+ZRwnDUjC/ZtK9mMiih/hHP5rRAOzgkgmkhFg3T/EC5lVCo8Qo0W
	 pq630FIjzLNkW2UHfHSC6rFXS8cmRUtgYXJU5Yehn0kLMV7MuZjmpr78JT6ZHJvSDp
	 o0FXXLVX9qDdZ6neEI4fd/tDmEMuQ7NTkJb2D0BIxO56sKN8QZB0/ECB0C1+LRI8MC
	 zU5zv1o103+rmQt5IHgcE7paB8sUha2P4oLZiLf5h06eDI/pfATOxWHJGVgC2U3fvD
	 0OWuxDUgrGFiA==
Subject: Re: [PATCH net v2 1/4] net: skbuff: limit folio refcount when copying
 skb frag references
From: netdev-bot+sashiko@kernel.org
To: david@kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, sdf.kernel@gmail.com, willemb@google.com, horms@kernel.org,
 akpm@linux-foundation.org, kas@kernel.org, songliubraving@fb.com,
 hannes@cmpxchg.org, riel@surriel.com, willy@infradead.org,
 ncardwell@google.com, kuniyu@google.com, pfalcato@suse.de, cel@kernel.org,
 jlayton@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Date: Fri, 27 Nov 2026 21:21:48 +0000
Message-ID: <179581450836.3135.326843222571201832@kernel.org>
In-Reply-To: <20261126-skb_refcount_overflow-v2-1-a6f600a5634a@kernel.org>
References: <20261126-skb_refcount_overflow-v2-1-a6f600a5634a@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: d1pjjixgtc9ud96azcgh7e9r7bqtbnwu
X-Rspamd-Queue-Id: E599BA000B
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795814510-152226
X-HE-Meta: U2FsdGVkX1+HVslzH/1VR5xE8iIIDKHDCYuDEHCmCrIMQKAqc3PTc0GRrUqtAbSTHRrjazd/OrYTb5TfzwymzhiqK4ZI/NHnTLVw7ymBTcMpK0Eik0f2L3oBdWRzey1mB+YpctENUNjYidxZvnoBSHRFzkWsAk3Q3nOJqlsLt0S4RiQCRttLQi677bAyyT5YVLNEnE/uHo4fsPaddRO6t5FwG/gPYtkcZdxEA6OkBXw+EaVTanhDbKORJlKCHAUTla0X0ELV6DYje3aU8oAL3DNSd9NluiAUK2T1acNsUB6SdUYSAGA3XypBGnnLIoJonsoaaeNzG8YYjgsjGFYjwdALhaRyh/g75iYYQ+P8FBFkxQt+/TDCNQZRmmrbCZvjyVuMHkniiQF0jOHMVER3mesnKN4ogvDaN43+t5B9LiOu2JREZuDr0vckVvz3TfnbQD/vPbUeRAnSZ8FNOrTN/JfdGRzmkiwlVA9KLOZHeA89AwzAczXCE07YtKquT+FWvqzjnT4uct+ljaUIOrYQg+lCX40WEg1u7yT/qrt7WmyLdHW2GQVMIlFcMCR3wFqay6UKUZYiznmftORmN7d/6xwmr+847unlSckBmU+7DIfwJ2B5E53I9BI+dYWHpLt3bB0/0shmcxDps0V0Cpj5m5cmCd9KPmhOmNRo2J05rfdfyr4qbeMI5xbtLbF+lApr2H7xe+FfkyBTo2jcGdG3hHLfCSahGZYUKTCmv7aCxe5WU7cwwtby5xiJODXZ1f3HyC4LuuduItiMedbIIcBRWA+ijbuZpPmY0DN6glbxSi2041fc3Yvpx7Mar6ABdz4PL44HStpVC1GiWitePzn07VbrjjxXFjwf0Na1p/hvZ+NhXAvAz4wOURlXRo+m/7NWQbsy3VJ1N/0BNamGSbeHladdpzNgn+22k5Mp2jJRGww2BK+dgiJKa4E9kzzBvWeVvWBy6Jm9ebsdDYcoueN
 xX6VNdBM
 PNDfQxuTJnnUyv3XM7sFvBIlXOzCcxzgTEzURoppemnV8moTMo6x8e9E3ThTO3TtRPOq7turZIIdEx+wlltKVqiqTvL/M2gxhw5GEGmGKKg78/HGQsDx8SopoUr2VcvUzArrnwGi1gWkN9PkPHF6wghos838WaiLSzUuksMpbppVwL2blIQBeN4d9Ogs8zZOxbVNiiDP4Ll4lJ4HlTVh0dJqze4BGVLvKu8mCgQxYMVM6dRZklAXdtxmnCMhI6+D1GAiP93LPS4w4Z3S9nSA7n9ZEq80kzX8r7+UIHOUlITGxtwB+s2Y2X2E4QV1xcgyil+dGUe41CLu2sBqkStO7SapOLdS3fBCA5L7BYnM58ipSsxDovRzNcg6zFDZzaSHQJ+yGczFADh1rNX3EKTJt66iYhsNT1DpdvPNi1lXNnSRf8zuP4EFt68oSvNddLzmMacf8GaQzkY2EozPsvQFx3JePBxtmlN0U9QkPqVVIutjfnyG3DFfK1hnUuFxbNj6zZx8dZUogvngYPfmKBmOO/wx/kkqCT+D/iJJ1dX/+JqhRuKDmCwDe9/h5AO02rheiaTxiKj/pI29MkZmQVJisAdjqn+eSgTe95E7Ev3xOCltPC7WGb8Uzn78nQWk6fNlT6zeK7Spc2QsumSoPrCfzOZUEZcTdhCA5qWHU/S06nnwn1TubeNLFZETNIMHKDnwZgdpO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] Concern: this commit converts only pskb_expand_head(),
  __pskb_copy_fclone(), skb_zerocopy() and pskb_carve_inside_*() to the…

--

net: skbuff: limit folio refcount when copying skb frag references

This commit adds skb_frag_try_ref() and skb_frags_try_ref(). Both take
frag page references with try_get_page(), so they refuse a new reference
when the folio refcount is at its limit. The commit converts
pskb_expand_head(), __pskb_copy_fclone(), skb_zerocopy() and
pskb_carve_inside_*() to these helpers, and those functions now fail when
a reference can't be taken.

> Let's introduce skb_frag_try_ref() and skb_frags_try_ref(), which use
> try_get_page(), and use them in pskb_expand_head(), __pskb_copy_fclone(),
> skb_zerocopy() and pskb_carve_inside_*(). All of these can already fail,
> and their callers handle that.

[Severity: Low]
This isn't a bug, but could the commit message mention the frag reference
sites that still use plain skb_frag_ref() at this point in the series?

In net/core/skbuff.c, these still take unchecked references:

skb_segment():
    skb_frag_ref(nskb, skb_shinfo(nskb)->nr_frags);

skb_try_coalesce():
    skb_frag_ref(from, i);

skb_shift():
    skb_frag_ref(tgt, to);

skb_split_no_header():
    skb_frag_ref(skb1, k);

Outside skbuff.c, the same applies to tcp_clone_payload() in
net/ipv4/tcp_output.c, and to iptfs_skb_add_frags() and
iptfs_consume_frags() in net/xfrm/xfrm_iptfs.c.

The next patch in the series, "net: skbuff: limit folio refcount when
rearranging skb frags", converts skb_segment(), skb_try_coalesce(),
skb_shift() and tcp_clone_payload().

That patch also explains why skb_split() is left unchanged. Each split
allocates a new skb that is charged to the socket, and the references are
dropped once the data is acked.

The cover letter (merge 25f5c92e1ac0) leaves IP-TFS reassembly out on
purpose, because it needs one new inner skb per additional reference.

Would a short note saying that the remaining callers are converted, or
skipped on purpose, in the follow-up patch be worth adding here?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126-skb_refcount_overflow-v2-0-a6f600a5634a%40kernel.org

