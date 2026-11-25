Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C611606A69C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=uB+i0aYA
Received: by kanga.kvack.org (Postfix)
	id 6AFDA6B09FC; Wed, 25 Nov 2026 07:53:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6876F6B09FD; Wed, 25 Nov 2026 07:53:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D0B6B09FE; Wed, 25 Nov 2026 07:53:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE316B09FC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:53:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C6905120DFD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:53:19 +0000 (UTC)
X-FDA: 85473632118.15.FB1EF8E
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id E02DB1C0004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:53:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=uB+i0aYA;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of alex@amutable.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795611198;
	b=onAIjN1ZIx3FUBjuRasPgVtZ8BInjwLAeCyQelQAS9Hpdn2YzS9JagDkBi+2S7UleEice2
	JHKuMThdbsMnOLQacO6XauupiU727IihcfmtzUEdgDA6CL0ZBhYmzeV8rJ8Us6u0F1mBao
	5n3a3JQ31SBLbRYyJmyIZYCmDqDCwXY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795611198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wb5N99RF+uLplURkem29zNIHwOiV4iL5+6TcWsB08Yc=;
	b=b7K9QA/o/pwotThKhQLvgFkAjv2bbVFtRY2TZOq88jBdr3MNmydVjqe458EWXXDtDUcZTu
	o5YpWDuzwBh7uttbBjFnVbov+npyi+tL21wfBIAJZqiYZEL+lxxvAloXTzLTpfqTSBMhrb
	WZBw8tDKHs8zp/2u9hb1/bt7FLePHs4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=uB+i0aYA;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of alex@amutable.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=alex@amutable.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso59426605e9.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795611197; x=1796215997; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=wb5N99RF+uLplURkem29zNIHwOiV4iL5+6TcWsB08Yc=;
        b=uB+i0aYARrqz1uuBdeYaxUBZ0S2PvTHnEQAHxG8kYmDG/BWygZoaak/XlaXBy/qIMc
         /zkp2YUfMe5gNQ0CmpZZfALJiNUOPQjznki9+9HBIbv/eEG9V2rr8Bj9YbXwSmj6p67S
         an9n+/V95gXPuUmvgCZvEnEaWR4GALbdpa6liSnibwe/NmsgaFiBaBUSHiE6VDMSTTkB
         FPak+DwhM0ILo7jSfeGhGyho5L8DUngSmX6v1W/lsP8rveZDv06KjjaEApw+1Pb5kSdI
         h/CLtX9D452iDQW0S98p5i9dtOGhQ6/Z1wLjuQfjLYZi+3Qr7/1JA6xAa64oM6o8bSrR
         EVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795611197; x=1796215997;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wb5N99RF+uLplURkem29zNIHwOiV4iL5+6TcWsB08Yc=;
        b=QtreE/iX/d45cfSB4YowepXqIpgdreGUHGaAnNkG7alus+haREJ9t5oHE0HAXEhcRz
         Z1kKvLWUbjphp7nRN0r3sMe9jboWcd8dsrm68Gdy0t3IYhubLCxZQJVn3HWg9zI66yUT
         0Dblry48nz0Mv6O+YHuxHPicp/0jUeEkfMJOLL67eXsMYnsioZqc+IxaiFeR4aD0QyOb
         okLp9e6X2lLRivBYPkMJNOtcVRdAmiNeZsz3+LtcKlU9LbxRVKYHXtpA1wUoXe7YQ1m9
         oIXArL8/5X7fQXL5pGvxqhsgPj2G9uNHHMxaAOw+nxKQTxyOLgK4DmqvqsiXCTRDAUTY
         DSTw==
X-Forwarded-Encrypted: i=1; AL+hErFL/mRuiwAp41uxEKdoSTHjzRzedQdD0a77BWIZKv7f21KBjftwn0yyfghulTjuMNOUZsQpxpb5PA==@kvack.org
X-Gm-Message-State: APuU4Z+7q1FeYgUlubbjhBJxCxcUcZj3EzmTZMiGnFhblAqN2zqfNQ2F
	Tqhdc0pd7mxvQlD47RGIFwVQvDiKNKhLaJpIkkFowSvL42e/0McnNwlg/c6cXwOn6Blt
X-Gm-Gg: AZFdTZfzNIJ9uUdspxTzWadgMJXTCi1hVTxfm9+NqcAiG0OzM3FApPJium11LFQLe0A
	3uMoxStfV4cfbrjgd9tn6LmD8nEZazcUkAqjKj5xtH4WxbMVlYB4VHuctaB5aDfR+JVpBCPNYMF
	roZk6Lo/ahTU8vcUgIaIBK4AdpsGKtMpA34QFHMVt+Ui0UOOMq1jdbka50QuME8+INsOFLZRTpM
	iywM6x7F6qpKXYb45F6uDmcZC7dHESBy1pk53TxSTLxVSEdn4Uzim5sKzD2ArSztLLXbvYpt1Ef
	en8c05rDscQ/OxXNenwYX662JRgguVchy0QYjO5BPcuBEgEy8FBnML6eZP1nuibfqTqx/cNtUzI
	nqZnrSJ1507WDjD0Z+2lsl1k0YD22FL+87jK+IC8e4pjoidmb8UFCO8UvnExVaNN/shee0ckAWZ
	k2pWTFSywDtvkg+voLvLicTWQfJcC8j7pL84KWdU48hTBZP1cY60Yw4qcS4YoEWtKd4Yhp+ggLJ
	M1dNO2VNc8EBKC6ARpxlZWoN8BYMfiSThM3pP/ai+1WoPOtrXlb39B4N1zALPhyrkaTTpdJ6um7
	Suv3+WqnPYuvD48ln5QD3HVbPFu9cLYEUcs6Cm2JrWUHEScsoN1zxw6ofkn9qiWPW9hjkpAg+up
	APXbrrJcBM1QXR4UtJMsItFaHWwg5Icsl/PQcjoAjRluM/p0qGeGz6ctQhu3OkJku40t23Ld1SA
	8=
X-Received: by 2002:a05:600c:b8a:b0:4a0:20b4:ba93 with SMTP id 5b1f17b1804b1-4bb88818156mr356853675e9.16.1795611196651;
        Wed, 25 Nov 2026 04:53:16 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:c235:97b:8b16:8928? (p200300cf572c2800c235097b8b168928.dip0.t-ipconnect.de. [2003:cf:572c:2800:c235:97b:8b16:8928])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b2437sm736573735e9.13.2026.11.25.04.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 04:53:16 -0800 (PST)
Message-ID: <45510e886330ade6013838f94cd84c688b263aa8.camel@amutable.com>
Subject: Re: [PATCH v2 08/13] ipe: handle errors from resolving the real
 inode
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, Amir Goldstein
 <amir73il@gmail.com>, 	linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>,
 	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 linux-integrity@vger.kernel.org, 	linux-security-module@vger.kernel.org,
 linux-mm@kvack.org, Fan Wu	 <wufan@kernel.org>
Date: Wed, 25 Nov 2026 13:53:15 +0100
In-Reply-To: <20261116-work-ovl-d_real-v2-8-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
	 <20261116-work-ovl-d_real-v2-8-90564c4ae347@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: E02DB1C0004
X-Stat-Signature: aob3sun4b6tk3u8tbfe7b5f55rnabkyc
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795611197-343739
X-HE-Meta: U2FsdGVkX18R0eEI6HXtLW5BHIZZQ/U1bqbpv1QtDyQIrymRNIZmpAbMpzUtE3weX5YNldAx1rAytaZwoI5eSUcJy86zPTaZCJIz0Ij6o3ot2+6tg7yMfBTEDFrIaGqjpyToMj0T4Lr4Eqn+MALtS/fgXGgEWShZ+vd60uKBSIcpjpcUOpa9q7iMgkdwQGJZ5SXFNaeYg4N0a/PbAZJ0dbWkMnKr8Go9X/CyI/EOp1nHJS/D6G5jxPtTIlFJQsNIS2ZcCUZdseKdG1yMtQXVe+IBhtutkrUEh8Zrv28luHrTN8W6mH1i6Ho4Slv87hFHbTOT+Sj5Rv6l2ua++hjLV8OLWGvxfXeo/Mktkr++I71hiCvywN78sGuu7i/oPhEtGS/SIFebWcM8cXWoLk9hyjkl/2wpF3s8MG9Zy96fKhjZgmSCUnxU402PZIFm1GG6PQAfkZkFys4fi8nB6z3WD3WIDUwgUPfDT3T9hFTTi5/HD/TUCDTMvomTRPloykDCa4ZnojrA3xd2LBt/46VEPH5YNIUedTSwgCjbPcDIskmDWNAvvLS0Q9H+QJXgqwoUFyeUSk7QdV+R5ZiX/bZ0fqQS6pgl0liPf0VNspzfcfTvUsX+txABkmA72sxn7++7yQi0ubfdH9GMEsCEmJl1XgITPsFEWxRHrqG2BMvtrKr5xOEMNcPIWDAMt4lPnPmMZ5MHo7hFeHypGDjo1wGAHSxBQ9RlXFPwWdP2w2T1GSgjYa9EPOfVFsAC9Fq0gHsHweYO7K0kFEocRGrzXOTqITpDYhatp4zKJfJ13/dXemTELrHfVqrdONB1K6hf8QnXePHflLhJb4K8RggXelXlZySMFe5bckbv+MPPT1fZvxhU7q6kqBmjxF8FHdItD4kL7FyLwXFz15Yb24ZSIxgC1FH0RO0zfi8rsiKChQ2ihqUONPAltLDT0Bg6ywU1BijoO0NvrOFxczDhXfY0iim
 aETfzAbA
 /Z/NCguvICuDB3B0kKVcCGB/VUoMQ3vnnkgdh/k2h/O80DP/EVSashQoKvyqOJOAxorGp9lGQbqMXUHl7huoWVCobqcMDkx1Ju5ddMpEpfI2i5QMpbZMGEav0axN1qlM4ESe7M5ILnvaWqIhiNANuL1+pOavr9fkTbnt4NmwhEOpV7SKw9MK120MAuGwtpX6fugvghvyck9hQzJiKOux835nauZ5/pnEGlTiGyRlhwRHV2JMGqOTk8v49FYIlVv8XigATUZepjEFKL3Hojrw5S5gqh1UGbdVK3L5FJG8hgv566gQBCzmNx36u3Dq0EW9ZIG7Pv75As+pqbJZwoJzzC6yE7+5nUiV7cdJqmzppFDKEimadVV22OF40Jp6CFtFG2oB2UBpd3xZxTtX2iF8UbHYbKfd180gilZ67gbW7p6wTN67acK0jPR9dsGfadpF/H5jb8VXlLOykKhfrleAkZBfUe8wwRAQJ589vFReoaFsTkOSl7xbfT7dxdwcedej3abltdIY77Rsx9Bq6ipAPKkmI4n+vgTUhYOobZ6RVq+E7rAW2ql3Xrs4urhvDSWyTb9v2GcWcoLw2af8Zet1Ta1pB5S/CVErW5liokYY2jJmlYXjLwScieM/UBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 10:44 +0100, Christian Brauner wrote:
> d_real() is about to be able to fail for D_REAL_DATA. So switch
> ipe_build_eval_ctx() from d_real_inode() to d_real_data_inode() and
> deal
> with the error.
>=20
> Currently, if overlayfs fails to resolve the data of a file it hands
> back the overlayfs inode and IPE evaluates the policy against that.
> The
> overlayfs inode has neither a block device nor any fs-verity state so
> none of the properties of the file hosting the data are visible.
>=20
> Instead, leave the block device and inode state of the evaluation
> context unset if the data can't be resolved so the file is evaluated
> without any dm-verity or fs-verity state. IOW, IPE reaches the same
> verdict as today but without looking at the overlayfs inode.
>=20
> This is a no-op until d_real() can actually fail.
>=20
> Suggested-by: Fan Wu <wufan@kernel.org>
> Link:
> https://lore.kernel.org/all/4e9a39ac-9ad5-49d8-b0c4-09e665504609@kernel.o=
rg
> Acked-by: Fan Wu <wufan@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0security/ipe/eval.c | 13 ++++++++++---
> =C2=A01 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 4a7be96c84f03..a2366eb9a47b3 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -102,9 +102,16 @@ void ipe_build_eval_ctx(struct ipe_eval_ctx
> *ctx,
> =C2=A0
> =C2=A0	if (file) {
> =C2=A0		build_ipe_sb_ctx(ctx, file);
> -		ino =3D d_real_inode(file->f_path.dentry);
> -		build_ipe_bdev_ctx(ctx, ino);
> -		build_ipe_inode_ctx(ctx, ino);
> +		/*
> +		 * If the real data inode cannot be resolved, leave
> the bdev
> +		 * and inode fields unset so the file is evaluated
> without
> +		 * dm-verity/fs-verity state.
> +		 */
> +		ino =3D d_real_data_inode(file->f_path.dentry);
> +		if (!IS_ERR(ino)) {
> +			build_ipe_bdev_ctx(ctx, ino);
> +			build_ipe_inode_ctx(ctx, ino);
> +		}
> =C2=A0	}
> =C2=A0}
> =C2=A0

