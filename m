Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C251E606A334
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dK3ByhqU
Received: by kanga.kvack.org (Postfix)
	id AA03E6B09F5; Wed, 25 Nov 2026 07:49:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50856B09F7; Wed, 25 Nov 2026 07:49:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E886B09F8; Wed, 25 Nov 2026 07:49:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63A006B09F5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:49:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAC681A0BD2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:49:56 +0000 (UTC)
X-FDA: 85473623592.06.6F468FA
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id CF6E61C0006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:49:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=dK3ByhqU;
	spf=pass (imf20.hostedemail.com: domain of alex@amutable.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795610995;
	b=ly2hFBeegkvsXJxoWeLeSJRjkU+AKfaZnxvxPySauY6VrnNyThhBGBf7bhRkblSxX+5MjL
	Ip6+N41mQeN2OFRFoXN3kg6na29VZAIGWugTGYWFLL1atXAl15b8One8TTTsQ8kx26Wp0/
	3q1uzSmkD8JDWTVKq+pSUKtbhV3Kfr0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795610995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Le4AwFe0WXouABp9DXzuQtZ3ZnCfLcbkB8kE/IdX7wA=;
	b=jU8xNYVoqZO9ZB+QJA0tqM577VHB14miuVkTGJdRyn7R+zIGxrzwQYyuv94CiJTgIejYBx
	JSH2jFzXIL7NkzzTp1iC+/bCXjpNmpXPKm+8XZUCbyGbbwx5U7vOuFmDxzsM49LMIIQ0Y1
	gaGfmGFHcmyQFrT95ru1mGtqJ4rB1AU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=dK3ByhqU;
	spf=pass (imf20.hostedemail.com: domain of alex@amutable.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-491f34b4e0fso2622325f8f.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795610993; x=1796215793; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Le4AwFe0WXouABp9DXzuQtZ3ZnCfLcbkB8kE/IdX7wA=;
        b=dK3ByhqUjJo4RAk73lAY2TFQngjJnvjSZgyeArOCFyUD9CYR7JZiux4e3KZz8+TT6S
         bk7IrBQZCQOXDfTlfq4/7mesgRQ7hO4Ek8zZxNIkOQP1vhkO8844AN3upm5Za0vcNmHN
         h9NUq0LLU2B+U2ZUdTlo/DnVSUItZXyjYmU06AsBKw7dVRnsgo3b0cTpnBNXMthXTu77
         Dr/oUl2vs64gKpuQqbBSj9IULoJqxYfm1qXmmC8OkQBKOwh4U13x5EdLFKr5Sq0F3BKQ
         4sWHPeUoJiwLD5uMKnQKBhaJdPNEAfqqHfCz/5yD2/k80QNSnkUWieKLNLy95GMdnr3A
         iqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795610993; x=1796215793;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Le4AwFe0WXouABp9DXzuQtZ3ZnCfLcbkB8kE/IdX7wA=;
        b=jS606ka0XQU5CsvYtuVidoyICP6zBQUaP0LbVMykxrXgeNRQ3+4VETfBpRxhK31UkV
         QDw12Gln8HL57Feh7eVAtUP7AyAIgJBn8TnWp55suJv7xx+C1MNGZ27Qoi0g3uUTgum3
         cPzweDVqfzJt2eOKNYLN/JSeZw84N28GTcsSfR+vFH/hLE3sJomGwxNNhAvlBVp0B85F
         xiVdNXJUUzE80/L2JSgk9248L5/XTw+poE4Xvi9mkl7fzXPrK2NKlhZFHlXdXEVSp4UH
         0VNyEux984Sx3v8JXuEanqdJj+sOPqo24xqm+bAsqtgzKu+JH+XffIgTM+m/wRBysHoP
         5AOQ==
X-Forwarded-Encrypted: i=1; AL+hErEv80DHWktNGFWu3o4KlEplf/PpqO2fYQRe7jY99OAxv20h4LmbUy2GgiTmDuwftiE3KsgR0ruMbw==@kvack.org
X-Gm-Message-State: APuU4Z+nCprM+OdVmG8RBNCmK7vSaXblB7qfK01tA/MpcVkJDNF4/lec
	/+k5Ae5ztgbRprvhUwBgmVmP2A1RqEH7xDZGb6r6S47NgEVFCT5VA3Eos/v+PZtF9AmO8iYbt3y
	QdxM4g2W5
X-Gm-Gg: AZFdTZejEP7VVwSuKoq1H/rz4wdibedLk13W3Nxil3BkZ9BLkaU+dPtrXCUMggbe2KP
	D70EQNphZqkRMRKbGux9j3GnUhM3+5G6eQk6bkLSUX+ZjwP7pRdadUAXhH5lnjVX647qmMuu3EO
	itHQ8Jzy1sDQ0RXA25qqk8GwgHrLhD3AYfAve7ViRzVLYT/fu/ZUpZRHe5RwT/VByxwq/SViDtR
	rHJ6zkKxDiuZpz4VKZGSPy+LWb56+Js1uIAiZyUevCv5sG6VEwS+ONWXcT8l1fpYCJOFNj+cYnN
	0rwkLR8hrEWq5K12m4wD72WCr3L5EvqL4pE+RCSFqU2L3i9qEXgoUoLWPqXLa36E8Yxnn4pBbwQ
	OOBIXQ84+bd/a11zLw5IkatI9gRBQfAo4YATeiXes2Uozlo1e3e+v1BKth5KG2GQ5zKvpPyqyAx
	ayrGPjjP+wEF2mwuUqThr1gOC35OK3UWE+zEQt19FfhUt/DxiImfWgR57LDLX0mSCES9cvmN3L6
	5Nb/URSdLIEZOezV1JALrGuCqkbtbDZhAnrbNuJebl5yB3d/EEj6CuzOXNbJ9VtArU/zsjH2RiC
	I1LzbRB2WfsPbBgid11F3Dic3Rx5KQ1xTdGe/eCrcMJst+WqtXB4sWCEOxpE4AuD5uhzb/9B8op
	TyOq2cR4shG1u4QHHvk/QkMttIAkZjHTpORzrevcdPHh76kW9uXYPpw==
X-Received: by 2002:a05:600c:a11:b0:4a2:e0c:2b0a with SMTP id 5b1f17b1804b1-4bb888120famr364999585e9.16.1795610993400;
        Wed, 25 Nov 2026 04:49:53 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:c235:97b:8b16:8928? (p200300cf572c2800c235097b8b168928.dip0.t-ipconnect.de. [2003:cf:572c:2800:c235:97b:8b16:8928])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm710678895e9.13.2026.11.25.04.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 04:49:53 -0800 (PST)
Message-ID: <34297f66e07c1a64d81205c7669801738676f356.camel@amutable.com>
Subject: Re: [PATCH v2 11/13] fs: remove d_real_inode()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, Amir Goldstein
 <amir73il@gmail.com>, 	linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>,
 	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 linux-integrity@vger.kernel.org, 	linux-security-module@vger.kernel.org,
 linux-mm@kvack.org
Date: Wed, 25 Nov 2026 13:49:52 +0100
In-Reply-To: <20261116-work-ovl-d_real-v2-11-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
	 <20261116-work-ovl-d_real-v2-11-90564c4ae347@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CF6E61C0006
X-Stat-Signature: cdp5pdmuzrnq7uq33zxuuywp6o1dn8hh
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795610994-458334
X-HE-Meta: U2FsdGVkX18ISbhP5D1HvcWIrn2kO1eG+F3r4W9qT/nFs6PVnwPWYSGT+gA7EiD6+fCz66+hknkQZVlHyGcS43SFXt1RRKAZZ/lLYA2u5Bk9WBEXRzjmJlNki91zIqN++kJKap+sZqLw5Y8RMNdkrQhEs0rleoM6xuBsa+Dp8aizDhGqlZ3tjKH8ygibHA8hU8RTYOO/6oD2MwcvPVxWAuZGNDpyNPgGsZoMguPB7X4iEb+2I75OH4Nl/iihDgC48pJWbIMVeqkPb7jZsPWiUWc86uzMo8qTEpgUffzgSjLDIXk+yLMc2vil2IbVszroVOwBgl0RJiWPBGugS34wCCbg5jvAFWI5teakLPHk0mLItwT1+qBh2A/aQzwxj2BZo022ojD8hyCxXlipMgFj700lGxPYA8H5iMjUq0k8PysjOyjNJeVbFnV2q0FPQ9QxfZJYD1aGhOXEKvCNM35fekRlzvXzi0zSWQ7YPhRs+9684Wk8SvehbflGlq2/ExPsOG6pjY8+lE/a5IPInZlYpvMq3e0xP6P2nBiSswPw3jrUm8z3Z+BIQ8H3+xfqg9hUJA7ZhAHraOu9XwZYA9z2172B16IyTLV1NHclWtmJGXP3zUVGwHnn+oaCYj7D+OaDIWHiMeVRBnv2dHkUXiXeQgcx8U1k79kZD204rNrH+x/sIKn4h/5pf65MQn8fUcvZ6QQ3dfJLDpKLj2lbRkyGwrlWdHbBef+dLo17gwRSdyWAq1AoPTF6ax6WjOkQ+BKpy+I/pWQASE/Z1zm1nH2KujLU4SQmAbqeTTp5nIDbQxO2DMaB9N80lzz9v2eW/8M4DejT+y8EsouGTU+jTgk6e2IcSOByTbtV9PkHAjgachOorydXFsrWtRpM9mYP2WJfUnl6gdb94elAX7HHjWXOVVpJKEPADg4KK+K0kugTX5KWNOA/W2ccwUGF0yYDjw9eXwCgMZFwLnNNCaLJ3sx
 9Oo4ZIY6
 q0Wv50n7w5XfXfeT7nXvOvCPGvmqDF8hB4jXjD2nZi+6GOdT2mYMYbJifGIE4QNdc10cphQBaSmgtdE5xQfv2YdT61+auovjg0C3j7arl5OhTRR6tLeL/rpomMn5NVnmTGbCySYlMK3o5+K8TmcoxsnN4VOSlBQS4tzx9uUEWLSz66/DW+hPdKuBxY90TNh6u+ze+QHvTnRt1SiJ8xp+z3GNzr2XFpPLX4erWLebaxtURFZi0aToGVFUeNQHoDnkewgzrDGqo42ynowYuVF8q6axFzwYzCflmG5CsDOhM4a2OPZ5babT31jS8OOlC6IdyV4wUE+p6b3KyZOeDx3Rm7Kb1MlVwvve497kVm0aZcreXNnKDD2oSRKqbCG/1nRGRgLUQUl2LE5jItFIOxAJuVyV4wKo0cYJvmPmJ67rrL9IKFxbqpXlRLqIOhFO11ztGt7a9063PlSD1+qofwXlFJFDE79FOARZb0x43BYFj9ywOb/k+Gd4Fla8CEvNuDch2+0G/soQaouVVS/Gw9rwPCqizUe6rOaJohgu3+vSkKaLNWi3ygg9B/JUgWs/cxP2EoJP0VUBAp5yBAGD0kWIqXyH1rSCg1Cu+Z887EypTxZAT2/cnmbBjrOnjW7ZsxdWu5iPRmEnKURkveoHD8Gbm6veZmI32ICSGtcyptAB69Uu+Fwz3m8PoPXRYq4ZONdjYK1e2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 10:44 +0100, Christian Brauner wrote:
> All callers have been converted to d_real_data_inode() or
> d_real_metadata_inode(). Remove d_real_inode() so that any user we
> missed, or one that gets added in another tree, fails to build
> instead
> of passing an ERR_PTR() from d_real() to d_inode().
>=20
> Add a porting.rst entry.
>=20
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0Documentation/filesystems/porting.rst | 10 ++++++++++
> =C2=A0include/linux/dcache.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 13 -------------
> =C2=A02 files changed, 10 insertions(+), 13 deletions(-)
>=20
> diff --git a/Documentation/filesystems/porting.rst
> b/Documentation/filesystems/porting.rst
> index c38f5df755bb5..aa0fc43907017 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -1422,3 +1422,13 @@ helpers take a const struct mnt_idmap *.
> mnt_idmap() and file_mnt_idmap()
> =C2=A0return one. The idmapping is immutable so nothing should have
> modified it
> =C2=A0anyway. References are taken and dropped via mnt_idmap_get() and
> =C2=A0mnt_idmap_put() as before, both accept a const pointer.
> +
> +---
> +
> +**mandatory**
> +
> +d_real_inode() is gone. d_real() can fail for D_REAL_DATA now and
> returns an
> +ERR_PTR() then, e.g., when overlayfs can't look up the data of a
> metacopy file
> +in a data-only layer. Use d_real_data_inode(), which returns the
> inode hosting
> +the data or an ERR_PTR(), and handle the error. Use
> d_real_metadata_inode() for
> +the inode hosting the metadata and handle its errors as well.
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index fd8853622f250..fe1aa8fea0c7a 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -654,19 +654,6 @@ static inline struct dentry *d_real(struct
> dentry *dentry, enum d_real_type type
> =C2=A0		return dentry;
> =C2=A0}
> =C2=A0
> -/**
> - * d_real_inode - Return the real inode hosting the data
> - * @dentry: The dentry to query
> - *
> - * If dentry is on a union/overlay, then return the underlying, real
> inode.
> - * Otherwise return d_inode().
> - */
> -static inline struct inode *d_real_inode(const struct dentry
> *dentry)
> -{
> -	/* This usage of d_real() results in const dentry */
> -	return d_inode(d_real((struct dentry *) dentry,
> D_REAL_DATA));
> -}
> -
> =C2=A0/**
> =C2=A0 * d_real_data_inode - Return the real inode hosting the data
> =C2=A0 * @dentry: The dentry to query

