Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942E6606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 18:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=amrJ4pzI
Received: by kanga.kvack.org (Postfix)
	id 97A986B0638; Thu, 19 Nov 2026 13:23:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B226B06C9; Thu, 19 Nov 2026 13:23:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840F66B06CA; Thu, 19 Nov 2026 13:23:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE706B0638
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:23:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C12081C4641
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:23:44 +0000 (UTC)
X-FDA: 85452691968.15.7E10FC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 347F240011
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:23:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amrJ4pzI;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795112605;
	b=dGUQ+kkOCcAXnqmFMT91Ka/LbXZ/rnQzjv4f8+ITzwR97T5i+HBmqKmtuaUV2E9omgsdDe
	Wmire4OxFnFJ3GB3nsCkT0feialnGdjhWmmPJ3a8GgC53ejn1asfJ84rJ9L/x5PXW7Y34c
	9GeZWgH2HQ+XmK7207l7SZDeBfQcnNw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795112605;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8mpR5ylQkmnGXWRC1m21E/yL3AzzQUM7LJwaY7fu9w=;
	b=Ig7vfxei2EfxoS9B9w0njdnYGoV4M/3dv0BVakK4Txq7FW/XAKqidcOlFqj0v6L/pScWMi
	kbGAzaDwqoy+nJu9xIQIbaReQmlQ7MGxkwWUD/UBBUq9yFxEmw1hU5z+VVbMdbzv2/VgBP
	Fa38zGN1o/7d8poNghMOFZ3rWkM4cJg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amrJ4pzI;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C657D60D43;
	Thu, 19 Nov 2026 18:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCBD1F000C7;
	Thu, 19 Nov 2026 18:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795112604;
	bh=Z8mpR5ylQkmnGXWRC1m21E/yL3AzzQUM7LJwaY7fu9w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=amrJ4pzIElTsGWji6XhhRlfF41ctICr/xuoE7aQgTnFgJDIFj5qqGzf1sumLb+MCo
	 Myes8EYfjtW1OrsyvSCtsLqwEWkAaWR+VbiE7/rLr55/7j4jrkAVcjDPtgyiEywdR+
	 I+NTq5YTFTXLm/bMIotAm5BcV0Y1JudFUfgl/Rab40i6DK0SQ26Js8CY2f2kGcG5GF
	 ZVsHiKDAF/iF4RQLRWdHnSuqKqerR8ZlIxhwNTRB1Rg8L56m2W0/on2a1emakncskv
	 EKsACL4kYLUeKRrxvtaWZsM5KSC97Z/us/SzztHA+dCNJL3d2v9dKDutE0U9DyFxc4
	 MWCbcF8QmVW6Q==
Message-ID: <sashiko-outbox-223766@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] shmem: consume the reserved xattr space despite remount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Morton" <akpm@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: linux-mm@kvack.org, syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Miklos
 Szeredi" <mszeredi@redhat.com>
In-Reply-To: <00461f0c866d4a4eb9f50792f0e1f3d0.1@linux-foundation.org>
References: <00461f0c866d4a4eb9f50792f0e1f3d0.1@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 18:23:23 +0000
X-Rspamd-Queue-Id: 347F240011
X-Stat-Signature: p5p477tecuo1acywpj5pzusdp4hi5acs
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-HE-Tag: 1795112605-35980
X-HE-Meta: U2FsdGVkX1/NBIdsdh2jeTkiETwSYZcf2psfk1SY26XrbEyjG6Q0HLGyV64Ai8hpoMAMcHgZfax0a8Sv6eAOZTgiMWb4jms2XU831q//DxB9JZ3VauYsSEOSe4A/QozcDRerSTqccFTBoG1FSxa/JSDpEPwovH7rGyjMNRJFXRVjcrg95yNuUeinK4blfu0ygv4Hzf1kV1A8WVeVGFvWHy/YSXOP9KKRfKpMnNcj2z+hIn+vHq3s2sLkjjZ5upHCetUGYEpJeuks24jy3YS5bClBzRm8C/39PlxOTijC7k2v1mE/jritd5HJXsIpSP73A5RrgYpPtJphcgvCDlQYKhK3xAHwukUYgF88CrgE43k8D79xmhKirLdQVG4bCzbmuIngu//EWyoZihve2GRxYun1Y+j+9BvR7blQeuP15ZB4Yt5NDSPs0jj+X2G776ZYBKEWpYQRt6auGG+oby3dNX2lYBuZB/YraP13n+GV5iMZHswrEIGAsl/urpiK9gOs34mJ/dvYMm60ZzOA9VXy7HtYRQyuNJn04ljQxq3jcPI3k7HuejWG0OKrW2M1jvxsL3ENH5vfYRVMxl8BZoSfzMaTSzr8qHwusIUkPcUb/TtsOR8o9yobDcEGbV7MSpYyZ8/R1C8n7UsatmgIXZVbeUuD6/0FEAy4Iuicb9HlcnKm+Sj/lcfFqARM9Gh0nkhYSuWbfuyL4ANkBMjRFwQyWdNy3CNqEOScw4W4Nz/F0HASMIkhtEwpRTw3dQz3fmzy1l7AwYBMNkLhZxOBIEUpuZJcb5xa7TDa4tlFp8u3E6SyBQPqwjMoYbTLUXwQcrX2ysd7Cgh9LDMEAbNwyiNYYFjLPWOm5VWzrnzqp9wLCppDzQDada1motxeTcJanUwIyOl5nmfrywhCKZ3FHA7WLZF2ZJJl6Q4WK3imcyhmg4hxrxOrnpdW6BCcm1J9raZYXXpatkcVIJcXI2T/dvg
 PAra9dZd
 pCx22Oj+nKOBgJuwHORBthvIs9Jj131xG/mcEKtX3D4BpLRnwb/jKw5cRwse4WL9Kqece9NJ4bv2KjCosMghWIy4W3Xh/RALX7ueV/TUbicoCrqhRGDJaVEuDH0sWBHZYUB/SfzOfwDFudhJUTthnQDtvLwxAKHqmzUfx+ncYjrS8Rp57jEe8+zd1K7OLQiRTg4spXPSDcDjW8KyEPDs41DFo91dPrNv4tteJt4hxShW5putpCWYutnjj8UtONnRrnNEmcchJJ8ZPep03mOvRPG3Ele76FnbPPB8Cvnt0rrnZMtqUd/ZkCHA95R9d3Unn1KGq2y53fNT9incph03tEBWfaz/Ejd36TbiIhN/3OL4NwopToMqwBOZLDexu3xHHWHP3LQ0Y1OF7pLz40uBTpcvwh1+Xe4Z1ooVZ69QfSGJDV5o0aFiOEcfrG7lDmIb6T8j0H+TbNWIwoqKFukRGhrpj1FGqoHVFkYaWN6sSKlVAN+pZkP61qoKRkRIWxbPXBy2CLw8/ENA7Vffjkjmxt+2gRhGdxvTvf/UyCJAmMoRO9wcu1FJDLn8orqbp8fqHO/DcDEUk3PRDvViFkSe9ba7iihi6lvUCnLNB6nCtc6LconlGSFWg0Ygv8mHEVF+zy6R+rnjn3EqqxRE7fyVyh6Z9Nertqzf4S4d+c7Fx7vdgRhLMh7g0J2/COSxfJcPdmo3TFZyX/BE6q7LIoF76NpneDwgTm0pD0k5cuGqidJ/gASheTVUmbC4WJD8BtbpAIoJMbRuBEp4ivsKbH5huD13avwm0H5V9I3l1uTZZwR4UFS2ilgLgSprCv+ntJJEzMdCqd1dNyCji8BWGPzfVFYrbRzvEnHIdshXVAcvtVWh8gs9cWOVUiK2vYt7J3qXiMIw6kXjo1fPPbuPdmQrm7uyOump0ZkdKu/a3TMvvfum1HlshfoFNYJm5C7Z2iYig0k9AWudZUm/tTPgHWcayE+i4xmY1
 ePYKW+Ed
 sfGpGrbYmX09JnmlTR2QO0irO4geHcAZMJPWE3LpZO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] shmem: Fixes trailer subject omits trailing pointer asterisks
--

commit 2c1ee388f6f3d6454e93c257214769e6a996663f
Author: Andrew Morton <akpm@linux-foundation.org>

> shmem: consume the reserved xattr space despite remount
>
> Creating a tmpfs inode can trigger WARN_ON(ispace) in shmem_initxattrs()
> when a concurrent remount sets nr_inodes=3D0.  With panic_on_warn enabled,
> this warning can panic the machine.
>
> shmem_initxattrs() reserves space for the security xattrs while inode
> limits are enabled.  It later tests max_inodes again before consuming that
> reservation for each installed xattr.  If remount disables the limit
> between those steps, successfully installed xattrs leave a nonzero
> reservation behind.
>
> Use the remaining reservation, rather than the current mount policy, to
> decide whether to subtract the installed xattr's space.  This also leaves
> the failure path with only the unconsumed reservation to refund.
>
> An initially unlimited filesystem cannot acquire an inode limit through
> remount: shmem_reconfigure() rejects that transition.
>
> Link: https://lore.kernel.org/20261105082717.c459bb33778fcf27e5675082@lin=
ux-foundation.org
> Fixes: 076e5cef28e2 ("simple_xattr: change interface to pass struct simpl=
e_xattrs")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com>
> Closes: https://syzkaller.appspotcom/bug?extid=3D4324f771847cecb27c54
> Tested-by: syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Miklos Szeredi <mszeredi@redhat.com>
> Cc: Christian Brauner <brauner@kernel.org>

[Severity: Low]
The subject in the Fixes: tag is missing the trailing " **" from commit
076e5cef28e2 ("simple_xattr: change interface to pass struct simple_xattrs =
**").
Should this be:

  Fixes: 076e5cef28e2 ("simple_xattr: change interface to pass struct simpl=
e_xattrs **")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/00461f0c866d4a4eb9f=
50792f0e1f3d0.1@linux-foundation.org?part=3D1

