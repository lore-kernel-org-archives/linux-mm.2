Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8868606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T8xH28H/
Received: by kanga.kvack.org (Postfix)
	id DA4F46B05B0; Mon,  9 Nov 2026 04:05:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55CB6B05B1; Mon,  9 Nov 2026 04:05:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6BC96B05B4; Mon,  9 Nov 2026 04:05:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0F3B6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:05:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35AF91A05E9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:05:31 +0000 (UTC)
X-FDA: 85414997262.09.B615C3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 97E22A0002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:05:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T8xH28H/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794215129;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95kQOG7UF205HxNJnA0g7sSyyV4+ju9wI7uW7uP1Qa8=;
	b=z33ESz8ZIu5N3pOYfb8TatjiIlBpdvE3YZviF68giM3scOkBb7guyNkdbrDrg2AEX3SGFB
	PEl5Dz6KFoG0fPlFFh8ZB29LDEmyQlhqcSnP+regad8/FBsq+kk4lFkfxe4N8H7MXwpJ/C
	t6aSBbDVwPT3L0W8Egw1TM6imMzU4P8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T8xH28H/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794215129;
	b=Q/rKnLy5ut5DoqmU1alxHznumjm7BUHS8SODgSzMBqb3TRXrK40CsKm+VHpQzAnvqNy0J/
	4Sa5LqfW1DZHMWSvbwJghru8y4Cnq82HRiMi1kroje8gn1plo5RPs8KzxRM4a+eSwtCp1B
	/v99ioV47DG/V9c/+gKpN/jqOQeHadg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3963362F68;
	Mon,  9 Nov 2026 09:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B421F008A2;
	Mon,  9 Nov 2026 09:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794215127;
	bh=95kQOG7UF205HxNJnA0g7sSyyV4+ju9wI7uW7uP1Qa8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T8xH28H/MJNyxVLh1qLwDA0lf1q2ywUF0qPt6eRSKqjsQCYsFpUruD0npOTnpHS41
	 1/qod5xM0YGlgRwY+Ui8694O9d02GKMyGP63aksP4CU9io/EFLpqeelSoDjqbQ95cn
	 Z7oGqfuc0G9pldrPbeSBklycM3sVGURPYBIfbRMQmWR+5VA242yDdkLvGDjq1KT5NH
	 BzEV88y7fugXNDCG8iZbQfBMs0teBXRBodeIgodv04Rbqekv98Z1kpylx/k2IjhV3d
	 Mb9MhQzquORJ3dYFMeXlPKCrTVSSCcIYDJ4Nmb5tEetyQYoYpdczys6ld9XIQosGbR
	 eLalpmC3kfyaw==
Message-ID: <sashiko-outbox-204664@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/14] s390/sclp_ftp: Replace get_zeroed_page() with
 kzalloc()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWlrZSBSYXBvcG9ydCAoTWljcm9zb2Z0KQ==?= <rppt@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "David Hildenbrand" <david@kernel.org>, "Sven
 Schnelle" <svens@linux.ibm.com>, "Vlastimil Babka" <vbabka@kernel.org>, linux-s390@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261108-s390-sclp-ready-v1-12-3e7c90eb6676@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
 <20261108-s390-sclp-ready-v1-12-3e7c90eb6676@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 09:05:27 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 97E22A0002
X-Stat-Signature: 3ii5i43jpduu5u7i3rayzt9mxb6rmm7z
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794215129-427437
X-HE-Meta: U2FsdGVkX182VoTLm70CotLtDSKzYZn9JfdLm39dzXUjouOVVxaDPKPA4bDYNBrvo+5FgX7O+aq8uk2C8RIRYbNAc1ySxxY2RrBHvkUUj5PP2sHH5n7/+QVaoN02pmX2c6uSiL0KVykQgvgTFs7DmqqcxovpCj0M06cwklq3fB/FnGbxTU/GqIfWlMrcCdXJ0BGRLYZf4qE/qdm+BlDi0qMX1EkfqvIt/5DetIn/qisU+iUBM2ICzqKMu3EwDlqC5TRN4FpBUr47KvGQvaZG7LHQ4IL0yu9VHpZAaNmy/VB3rOnJLQX2T/fWnQK2ZTrNr99hhFTuXWna+3niLhdfPChmR8tWKEBuBdtWNEqHd+EHj3KwI94Mec3ro0i3Pt4bX74cKHW5XBhovfxho9FjgvRpEySC6JJyJePs9Qd0cYQNb6hGQ2bv7f4aiwNKkYpJYdcq4tMSNSBcMB1FwSDq6VUuyRMx3PQiVGGSZjEJnalrHBJlWIjLYQmaas3dq51t2VQYIweTbrJwwKha3SpGntyY89w7Yw6FW/9ZMPH08EFsRt/NcxhbD+qraK4UZJnqRGX2JFj1ylTOJDavH99tL41jJJxhe4M1IcXYuyMDEPr/+WwkOOG/pszrsXFI/T15CZCy+X/860rEv9Z8JTsAULUfY6ZWpt2KCJN70ugFXCyjLgFQ5sjlxdssgQ5w3IXszuGp4DYkD0M5LUJATG+77FXUGsGGvZcoeo8cvEMnHMLvGpmKE+1c/FnJ7DrcIaJFgdvp6rAXCm6baFXkLCeTOSQYIuC0ehp7Uabp2sZJFmcgiaLbvr7o44zbtJhrHceK3W9dJlambiBWf9om9QJoHZ7vRtEWhDNYXL3zisXJVOUMpZy+ph/5TJ7ex2xEnlNda/ivPMfwuXMfmZ/StCJ3mhqaXEVnS3fsrSlwOZNtONrOAu4uGQHyDZcIWmF7noimq8MQ+41HoQemTx+1VcN
 tcG+zyh0
 nvX2KR7CMdCm8KhS1aIOHQPlewmwdgLYtyAASaoCF/QU2psXDZ0NldCG2Bw+CL6wWrNOOo0gf5HjXlI0J4lpQQOn9EKGWjO2IRzhpYmgQwikH7JXfpUP6dqC4yJU5rAoeX7lyyzaHdXj4QQu/PL0Jo/+TBzfR7tq2xijd/kW5eStMJEX4Yhw2ZNeN2jXwQzZI/IKv4XkobQvCQBVre6K66EHktsaiHXjB6ZHTaQWfqhuXsk0thHOAnCKzQpX46KOttBc+MUzsw5A615pfI/zkG+/siR2iQOt/HP/4zhoF43QkbgoKNc0gWBck7jCmLBT7ORN85sxHxMaLiB4zB6+Re3ClVOxNU7sgA+Yk6qX0uiaESpdL0hGXh50yTtxApU7qFZe44t6cBXPzwd2h8GzvGnXhtIwI+ttUK8U8q7qxMwE1HfrFxz9ZN/HBmZ/B4uT7u60w6S5GbjovYKpIGtOX+1yiL+F1nC9eIfGGzVD2gNkAxq2XVCBYgiUkd1ixcYBEaZL64S489aspnjAOL0kQspAvWez9pXK9GJW0ta8HJ1TNyF18QUig48ElX6IaSA2z5hU/wBL6gf1T3axZ/9/YAOVunc67qh17AGpq1dgY+Z2XM/4HIS45M8x+6+QjjrAjizEmYFKAHxU6gin3mCNN364A3Bd+ZktrXkySpJ9sSrC075XBEoPjhd+LylWXqODNU0MT
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
- [Low] s390/sclp_ftp: unnecessary unsigned long casts in
  sclp_ftp_startup()
--

commit a25923b8503ee3e56046245296e0025552cfe251
Author: Mike Rapoport (Microsoft) <rppt@kernel.org>

s390/sclp_ftp: Replace get_zeroed_page() with kzalloc()

This commit replaces get_zeroed_page() and free_page() with kzalloc() and
kfree() in sclp_ftp_et7() and sclp_ftp_startup().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redh=
at.com

> diff --git a/drivers/s390/char/sclp_ftp.c b/drivers/s390/char/sclp_ftp.c
> index 853492d53953c..c46fd056e9daf 100644
> --- a/drivers/s390/char/sclp_ftp.c
> +++ b/drivers/s390/char/sclp_ftp.c

[ ... ]

> @@ -250,7 +250,7 @@ int sclp_ftp_startup(void)
>  		return rc;
> =20
>  #ifdef DEBUG
> -	info =3D get_zeroed_page(GFP_KERNEL);
> +	info =3D (unsigned long)kzalloc(PAGE_SIZE, GFP_KERNEL);
> =20
>  	if (info !=3D 0) {
>  		struct sysinfo_2_2_2 *info222 =3D (struct sysinfo_2_2_2 *)info;
> @@ -262,7 +262,7 @@ int sclp_ftp_startup(void)
>  				 info222->lpar_number, info222->name);
>  		}
> =20
> -		free_page(info);
> +		kfree((void *)info);
>  	}
>  #endif	/* DEBUG */
>  	return 0;

[Severity: Low]
This isn't a bug, but since the commit message notes that kmalloc() avoids
ugly casts, could info be replaced directly with struct sysinfo_2_2_2
*info222 here?  info was only declared as unsigned long for
get_zeroed_page() and free_page(), and keeping it as unsigned long adds
two new casts in addition to the existing struct sysinfo_2_2_2 * cast.

Also, the commit message says sclp_ftp_startup() allocates an SCCB to read
SCLP info, whereas this buffer is a struct sysinfo_2_2_2 (SYSIB 2.2.2)
passed to stsi().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108-s390-sclp-=
ready-v1-0-3e7c90eb6676@kernel.org?part=3D12

