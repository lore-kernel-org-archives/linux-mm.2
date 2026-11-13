Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E252A60A2637
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=MJuERGDf
Received: by kanga.kvack.org (Postfix)
	id BD3956B0652; Fri, 13 Nov 2026 05:05:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D6D6B065E; Fri, 13 Nov 2026 05:05:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26636B0678; Fri, 13 Nov 2026 05:05:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 745746B0652
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:05:38 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 070D9A02AC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:05:38 +0000 (UTC)
X-FDA: 85429663956.15.A72CB8E
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 28E5E180005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:05:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=MJuERGDf;
	spf=pass (imf24.hostedemail.com: domain of alex@amutable.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
	b=GkEKjCMlmPcbFfCBlvOjQFQ4buIlppi6IW1CzxoS61UBsvqrBjG5sUtAMp1VOCipNBcFWi
	Fb2aPz166yZ6HxeOsco+VYMiWZ668PDNkbuZNKcBc83+0YrYjCH9NGx4X3HD6arFnWETIs
	JSy6ZX6lwZNcWrodljRaHNDFg7bynJY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564336;
	b=wJsy9CgPismm8Ru508coKEFOaAhk4U19DdUMIDziugPYJDEhO6kMbmqf1O9sGASFiY/cAx
	7MqUjzwaWpxFyv/Dt/8eoO74lUv4grhuUeqFbvdqpCXbMiyB3f5uYGTKDsL0wunY31k3vL
	uh4aRLR/fUbdTD1WPkSI0DzOJjyvTKg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=MJuERGDf;
	spf=pass (imf24.hostedemail.com: domain of alex@amutable.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b7bfefba55so1543276a12.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564335; x=1795169135; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=MJuERGDfko4anajtHj9Vw084cCHnwQa3iLJetQMRKnbeQuBBHbFOQc1m3O6H0xmz/9
         sK6sybXaMVkCyjlF1lYRCjfuVGRRa8+w13XSftH6B/3ajjLgouP/Kt4AI0m3rL3T2MN8
         RTY/8EQ6fH711y+4gcIN4wmzle5eFMWcVuYFxRDcifScPu9fbDKq+zfxtbMJHb6SgQZK
         uy1DvulaYSyvDHZMNBCGbKPjK9CN0rMa9HmO1d9bu6XWnsIgkYJS7SHlTeI6VO7oCKdc
         X5LgJ1tdXrU0/yv8baW98fey1IIZVwSJTVduogO6okmkLzovz62ZC58aJl32ZWSVdkhn
         z6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564335; x=1795169135;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=Fy1FnXmSKNBrPkAsn3qIjlPPy8W8nUzHf+95K1krHctpnpcTNLjmp0PXjLgbXLnqPM
         vf5f7lc37Im9xjFr+7/agMVmH3TADE0gDHKbMmcD6YJAnExyezCQuEefiuF4v8FeEmQ7
         opaarEPplRpo2bndLcH9/WE11q1n1FiV24ce4QsAtraZRkuu9/gxCEcD8dp/ufqeY+1G
         0VBCGbWNNL3huuS8uP2mV/uo2YYqj8Xa/fGLzNdFpt1UqrYDUZFBRapskTsIZLEfyx2G
         4uazXgzW11hy27Jm9Dot96PfIrdcSi0snqpvgePg26Hpx0uRUsT/iGKq/EbDyT86Rhe8
         xcvQ==
X-Forwarded-Encrypted: i=1; AL+hErGXIV6Wl1UC8R9fqG7rEtt41R18B9blnKQ/5gK1bWX+nPsTOiU7sljbaeG4Atrd3qTN9JW+bKw8tQ==@kvack.org
X-Gm-Message-State: APuU4Z8e2vGFgRkZUK7CYat/0ozqwyZ9zJp+auGImH1UPo/tSZ7uzzqG
	auG9oERnUqOA96MW88+36LS4loVHNq/SOLtPdio9szcBUExa0ocVlC7omLRyvRzovSOig47gf32
	BCbZxjfGqjXk=
X-Gm-Gg: AYBFou0g5xh8XbOEZZvC6UnIc6vLrSW4p+h2uPx1MHCkUmp/vU3M17Sm9YpKQaYv/yo
	kyVKmYsCgXL1oCvTb1AWZqZ4iGtWSloimbaty+0pKewkO3p++FBAZn7yBa0WZY4jyPnW9+GUHwW
	tuugfY3tDUzqCAq1zVnNuhZFOApUYGz92B5PAcvxNAORzJotWLqp1wD0einTgdHUpCIB+cA/ZqF
	RG0kXxVFwK/XibP4QGkGZqP2TGEMHkfCyLNQ6AH+nJ0kzPHEpLBWB3UhcStcZfM1IkHV1PFLCFn
	oI1Byx1qk37f/GqsKNjrkug1kz+sZiReJOps75mzXoq4zrccKlFPVfVd7tb+nAx7B29LJtlI8vn
	CuOE0d8wFxDxU6oR06olKTPMeAsi+1ed3Qty4K+0MsydsDPoa5oznsXK1ksFf9xHKWemJq95p9B
	fw05+SPvc4L7rH5fucc4I10ngHjaPBQc4hgWnPfVkKXSUUJECgEJqQPDy/HSBvoTg2DSKxOP25h
	8EDVpEPAtyICZrFRJvu4G/JfOzmZ/ttc/ad1RlhFrmCaSwhQzBvetXI7LFOyvB478cTmNbJLsdL
	6aAtLPkPjyRRwC5IPuP4Nu/lmPM2xhsSRK570qFTFu/fZ7cjal9ngjWwpVCmpus=
X-Received: by 2002:a17:907:608f:b0:c43:eae5:ee80 with SMTP id a640c23a62f3a-c5096398b03mr148720566b.17.1794564321873;
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b7b2c9sm75811766b.73.2026.11.13.02.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Message-ID: <08fa1be263cf4a3db6b3e5ec2847107fba7acfba.camel@amutable.com>
Subject: Re: [PATCH RFC 13/41] devpts: use fc_init_pseudo()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:05:19 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Stat-Signature: rfetrgdp5pskesqq1kqcndgugs44ys8o
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 28E5E180005
X-Rspam-User: 
X-HE-Tag: 1794564336-126490
X-HE-Meta: U2FsdGVkX19qFDH7+OFjt3vNCrax21wZNGDf2gh6pKkNdCoKiHOSSR4skMt0fnxmB7jroSLxoQkGz32F2HREsSkh41OyBokIgRMGz6WzJgfWa3z+uKhZOBDCWY6aIt5ZSJF77GmGNDlznOXwlv3G4TIXLAwp8ycBdy79nxdfxnPDozUaB/dBlNxgc3VoRc17Ez2ARAcRRWVhK7mjO9lW3Z9BP9fVyE1VSq5HaUPlWACPTHzvEUjVbsP09HFKdDGl3kDCuxTmY9rTyyVzlf5KOjm8feAWTWSRPmVqALNF6YZyPsc9plLfwfLRgyKNijp2P4N7Or9AI3ZhJmVHbrw1goZeRGOmDBGZT/ysdCFQlcE9QdVl/ocBk/Qri/5frsACfWVLsnJ6xGwqtBG1ungnh5aKHF6ZieuI9NX56tGTpgJlIVuLkcc0YP1HV0dexXYlRFfo3rcY+By3eTPGnVRDxFpPs5oMrbpvcI2sUmIUBUBstjEnYa3sxwXrZoAENCcv33/jypsgurme5HuuAiT4zeyAQZAcXv0K4IRhiQZ9dCNAfmJX3vp/kbLNQgBtZ/dnTrvWUJN4mfyeBiL5SJUt9BTJSTot29wcTJJCGapth/GQPXdW4mvsoKkUhIJ6Gm8iVwaK2nwdED5SAHTTl5OaoQ77nWmN/PXbG/BqXTJEAQekS/7r/UqzjeGA3u/nDxOT46/YNoPduFSSgZRXEwnd6y7MHFxY4AGz/bjYLXOT8wdbTLqlicuJ5/qbp3R7IfOsUidWvL4L/xIkpr+nzac3X86YQBplBMRCpqOKkzrB5IEr/BBok8yTRwe+y3Gs1sdnfzcQHQb79XZCkqJ3ceuRBJ5LfSs96+1Uaftsp0DVcMHoLfTwz0pH3veOHV/3LQx54fvlWBGysJySgmIZsoxO0IiCHHVwl5MhsPc4ikWVIOf3D4Nsl9axMwvgqyTLuucqstjqw38o9Wr+84MPD93
 vbUSRePS
 +lxJN54JcxMYvQs2DGVgl806sI63Ly03H9pS/RU2LsQK26gNZ5Rmtef19lNaBSD1HE5idnjwhq0tG5RmE2//Eoboag+AEZPEovQpyn+iEWLZLhKUoBHBt+M4oQHKc4Ust5i5bmU7om38ZKVEMxSgfj/wwGOkXWJJPnlHVamjElHCTPVJ/q9NbUqTe2Z7AZuMfnXKaLVk+/0R6kMuNJj1zQdUIxZwDR2+Ygh4qU0HOcKws8702lLRNfYB5EVs7T/CTaiVewV/wpGaBUSVkpomHX0Mbl9+cin1/YZK3jSGhCnfzGHXYn94Fm5QLtUTlmb32GVbLcgfPHCKyj9eXWiuObzX7WdZxhzMhMSR+Vx7SPcGtazqm8UYGbnAY5ZHlkpLVKQeogdz8hrS8haQjcEKX2bNmyC+vm2EJJEJufVC9GCrvv2UXJ8kdoxv8OvISSNa1N7vfaPCyt+7pxQHpkFZo/J6mPsrT36FDFfoNhCYtXrAUUr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize devpts as a pseudo filesystem. This raises SB_I_PSEUDO and
> SB_I_NOEXEC. devpts never holds executables. devpts_fill_super()
> keeps
> clearing SB_I_NODEV for the pty device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/devpts/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index bd1e8eb26edb..47ef12241d92 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -13,6 +13,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/namei.h>
> @@ -438,6 +439,7 @@ static int devpts_init_fs_context(struct
> fs_context *fc)
> =C2=A0		fsi->mount_opts.reserve =3D true;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &devpts_context_ops;
> =C2=A0	return 0;
> =C2=A0}

