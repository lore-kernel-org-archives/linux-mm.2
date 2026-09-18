Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92422C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863CA6B0088; Fri, 18 Sep 2026 16:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814946B0098; Fri, 18 Sep 2026 16:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703936B0099; Fri, 18 Sep 2026 16:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51F696B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:13:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E6B3C0753
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:13:27 +0000 (UTC)
X-FDA: 85227982854.24.4422372
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E605918000D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:13:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c2D0ixt7;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762405;
	b=0dSzLibm7KpIn8dplYi0oNLWApgkGg114bj3r4TnwmLRHyhYHXhRLsiLn4iy/9MOrndFsF
	O68Jx50wPVxU8nnR1oBhFVJeA/9eYOIpDOd9A6kyxTzEfBSodER4jwhYEP8HStcmv/epwT
	ORWgRQz8xaDPuZ6uSLw8MXNNvYqCxes=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c2D0ixt7;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762405;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhfaDetL1Tv74VraH8efY7aPfmn2/awy9/2560eVmv4=;
	b=lhjmFjJxo/I8RN42gtuZaQGDbtHiH0+4J43NetT+igkrYhRTywfXxABWMZOSuAqgrT7dnH
	0SPt4vg/Dj4mNY4GHY9H0BpiAEJuIM0PwVjrqiXkPIvlfyQN1rccv3TW9b/OUcGdJQbIpx
	e0+pmsha2prK+uBL16w9F+ztJlf4Iw4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B697602CC;
	Fri, 18 Sep 2026 20:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987D31F000FF;
	Fri, 18 Sep 2026 20:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762405;
	bh=VhfaDetL1Tv74VraH8efY7aPfmn2/awy9/2560eVmv4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c2D0ixt7SdY2SGgfpEcGVOwKxPpgIgHPNI6fJUCb1pwoHY5HHE8zoEEH0BZ6gZ0Sr
	 /BLYVOhP6Rgc384qGqrFpI9J1eWiexKj9FFFE7OOVaVWGuXSfLzlcx6GiRyNGvcPKy
	 4pTmnFOtkzelPFI9uucqmthqaSz7i2vUFGBPExR8B3P314nvDmm0hPoV60RfbRZiq/
	 KVrhnvBPKXgTEYUxEALxM16oKhGb0Pvs2LZsnAlVm8xYb//HYPpgD5Wj+q4YgO0uiS
	 RUWCaziVH6ZMq/xt+twk84Kj4GNYrMoeQB7P4Z1wYTTCOjeai8ePTMey+f6kRDkETh
	 7EbFfaX3KZr+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 06/13] PCI: liveupdate: Preserve bus numbers during
 Live Update
Reply-To: sashiko-reviews@lists.linux.dev
To: linux-doc@vger.kernel.org, "David Matlack" <dmatlack@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: "David Rientjes" <rientjes@google.com>, kexec@lists.infradead.org, "Jacob
 Pan" <jacob.pan@linux.microsoft.com>, "Leon Romanovsky" <leonro@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Chris Li" <chrisl@kernel.org>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Vipin Sharma" <vipinsh@google.com>, "William
 Tu" <witu@nvidia.com>, "Parav Pandit" <parav@nvidia.com>, "Bjorn Helgaas" <bhelgaas@google.com>, "Alexander
 Graf" <graf@amazon.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Yi Liu" <yi.l.liu@intel.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Adithya Jayachandran" <ajayachandra@nvidia.com>, "Pranjal
 Shrivastava" <praan@google.com>, "Alex Williamson" <alex@shazbot.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, "Lukas Wunner" <lukas@wunner.de>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Josh Hilke" <jrhilke@google.com>, linux-pci@vger.kernel.org, "Jonathan
 Corbet" <corbet@lwn.net>, "Mike Rapoport" <rppt@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>
In-Reply-To: <20260918200640.887030-7-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-7-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:13:23 +0000
Message-Id: <20260918201323.987D31F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E605918000D
X-Rspam-User: 
X-Stat-Signature: yjktbocpiutd477bkgdh7fbd4n7wbse6
X-HE-Tag: 1789762405-80567
X-HE-Meta: U2FsdGVkX19Yu9sNry1F7Oy0DQwvRbBBBkCB8lrLhecbjOBzrZ6745bs+RGBgDrhjOxLsULRj0kla+qvR6Ifli/GH+JwtaN6xF0FlF49750VxLn1ouprZ140T9iqBglSMtbGrE1tDLXnIOsXrk4gZdKIuF2Ob9MV/Oe9nfVnWrs9rfzlj5vYh1+a1CvIKPcftj5/UNSDVaHTd34JDlmDmNqci4QGC3ZnbD7PxDwex+5GVR+GLLbVxSABcTUz00rwqT5e4Ip8Vgf4E/IyeTyvnMeQNDQdkDLG+RLBH7uHX8T0wBiV6Vm22C2FD00UItoHxNymDofvS6oGIkaGvwAzpmT4MxkOunTGbOa936EWB3i/51MnJNCOntGJ98MxX/W2YkeiJG4PpnqdwpaFzmK/MU5paAQNRKYibfNRDxlKB0UvjsMhMOQ3mShrvKg16AlhhgTLMd8f2HIztRWjbVm00VRyAQcA0tRXzc521HzXqvTVrXs/DGIEMzICkjR+fU9c+YJmjNB3vjmvlxeV7wdnJ2yIyHuGVD6UnbKrW2JIIPmCGUgQqmbz9Z+qYY4zVLsHKl8EJQTIru0qYPiZghvavA8uzJSoEgL/pr/xtO5skdh1ZkKf5wj+VJUkKc+U01F6nsqMSOartIeA8V7+Zka81LzSvYWXwe5NajYHT/jCcbnzMQKacrvhP/h80H7aqwQeNM7Q5mVP1Uchl+KTJtwSCKHVej23DheNOWKBVjQAU6RBCMOgdQu9d0ZGog95IaedTCP8OVHJywAMItnl+Qwko6lswzsYDIaLRLRgJiIlpAWbDMbhDSoUzhrGOGGMBiJzA77h7aZUToWaRlMo9zljwBYT4OSnF03IEDemEunMipTV/lJ83jhlCqDS0oQgn+Yti8fwQN6ezT3rjIssc+bri/3as4XaFW22gTkrnsnQ4HJM8W1rbiIEb5iMDoGAHHcONp+dXC8DDl+1dAuN6Js
 OqnfMKm1
 Eoc18jIhWgVZ3u4pzaFc8abg4sLxKhKTk/oJ+mIT7ZFnrcxqHc/Gm/9U9Ff1zIDKH/2hw9/llJERB2qO4qfR4s685cNn2dDMdlvtnGPcOIMGLt3aGWvQEGFkALLdx5MV+qx5Rcu45xczTq18HQraUb5NgHmWHcty8xhT5BWELetlzhJ4F1LEQrl+mP2PnU5Xget7il1uDopuoEOGFpZnzkE+PnryW93qyZzag8CadPlQxp68z43EWuvzVoVhlaCAATn6iGQyb5G4J95oBvv/GegkVdWMZSZ229nS9YZt+KVmP/w04uoDbTT95G++qt0GKnzVOV4fK684Rc6tyigUNqkDMPeEv4vcSS7Y0eWD2pq58bmfC0fzZA4SIZ9djbcwj8x7TtIC5HaAa3uPQHdBs+Y7SS7sJnXExIG4SwDp9oGEnezRXHRAKXFtE15z6X4RhvJUuj522ih4lbMU3XiX85x/LNMcqAWDnuv7GKOuWj2/7dCi+MUkdZOqEN/Krdlvh07Gh3YQk254lK/LnroxaL+il2yOxLTB9X7SthkIKjms4WXkulGgg1bTZKOVpA7+4dmABMX5HhWwl3k6HtzbJkqnDzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Keep the secondary and subordinate bus numbers that the previous kernel
> programmed into bridges, rather than assigning new ones, if the previous
> kernel preserved any device across a Live Update. Do this even on
> architectures that would otherwise always assign bus numbers themselves,
> e.g. when pci=3Dassign-busses is passed.
>=20
> Preserved devices must be allowed to continue performing memory
> transactions across a Live Update, so the kernel cannot change the
> fabric topology. Changing the bus numbers of a bridge changes the
> RequesterIDs of the devices below it, which would require disabling and
> flushing any in-flight memory transactions first.
>=20
> Apply the policy globally rather than only to the paths that contain
> preserved devices. Bus numbers have to be preserved above a preserved
> device anyway, since an upstream bridge cannot expand its window. A
> [ ... ]
> Require that CONFIG_CARDBUS is not enabled to enable
> CONFIG_PCI_LIVEUPDATE since preserving bus numbers on PCI-to-CardBus
> bridges requires additional work but is not a priority at the moment.
>=20
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D6


