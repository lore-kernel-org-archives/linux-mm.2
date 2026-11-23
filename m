Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D334F606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lbJTJRlm
Received: by kanga.kvack.org (Postfix)
	id ADD416B05C1; Mon, 23 Nov 2026 14:07:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8CCC6B05C3; Mon, 23 Nov 2026 14:07:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9563D6B05C4; Mon, 23 Nov 2026 14:07:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA496B05C1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:07:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95FDAC0A08
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:07:09 +0000 (UTC)
X-FDA: 85467316578.22.A78801A
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id A7826160013
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:07:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lbJTJRlm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795460827;
	b=LbsRC4izdENGgzFFi7ewyygUHAssMpKMEnJw+KD6Ea42YOm5Uwp3dBLz7J4/q96m9Bs7I+
	hqhDDvhlWFlYfA3C2pbQZwMsfA3LsqCz3JV/DVLBYJ0txj4cyhwoSmMyCuB6QYjzX3cJvy
	jF6/oh8x9p0pq8plB3qNzHv90CwZSL8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QayBEQiT3Jk/QfXswrgR8TXyR2eeqhw4QSoy3wq6uU=;
	b=fyQ3LrI9msDg+M4BtyMjqJCLtElXg5v6i7FcwBMe1Jq69RrORdWUzAStbZJ7vRH/GBaCJo
	7MYJIHaO68J9QjiRsnGFIUwDPie9GGchgazvSmg93FqbXT9EBQMF0b/VL0EiarS75RhrKv
	bE9PugNJXYZtkpD2V+g4uiK6McexMFI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lbJTJRlm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b4cd193b50so30195a91.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795460826; x=1796065626; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+QayBEQiT3Jk/QfXswrgR8TXyR2eeqhw4QSoy3wq6uU=;
        b=lbJTJRlmP4AsBkO6Mbt+3H2jkozQRwXWcCbDzhxIVr5ePlxhDiCW3MXGxjGwmAJ+Ub
         bM+x1e9s2GSmSK8YhoGsK1tiITC7xgbb4p9mQtDXBQRr/chCfWAbbBNkClYEErxn4KKz
         DPo5J78NM6LyXFpOKlNcvGykz2rF9BVNYaPK2a7ecBmFNCNwU5Zv9TEOYDjob3UrGI1b
         qU5QOwOkG9UuR9HT/WmtqMEJNIUoRBxhgww/EWajS3o06PPXzE3wRaSrccoEthO0MqYz
         HBFoLxDbOvlgZV3H42ObLc203vvA5XNUTu9oymRkiBI8dFrdN8vh7c2lSZCz1eTpLY6d
         vw7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795460826; x=1796065626;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+QayBEQiT3Jk/QfXswrgR8TXyR2eeqhw4QSoy3wq6uU=;
        b=sfQ365sL0WE4Pqg5Ykm46vewuXwsa3xeXxW0bMN1aYjFQVOt9nG6cC9VA7vRu6V+I2
         1kNLBKURIpCkeB+N+1gDP4S713xxRr9CsK7hGhymjVGrzYxMhUXk/iETX6g+K5ABaNoq
         2e1QnLH47eccVD8tx/RJ6JAx9M71I4vlYi60BmRPTSbqwcDKhnUGIJ1UIVSWuFiQk3dk
         YA9frhmwutL9QbjFkFhvQsilFMtwcR6QA36b9YeF7w+JlXZGsx3hgFrjz02GMJjscSDU
         9i1d+dQoPAE845K2/K1y4pJ2vvjHH59mhbIUb1I6mw1VssllCbIyZlHWEo4rwkxAzEBo
         VKFQ==
X-Forwarded-Encrypted: i=1; AL+hErFlr5E5bIdk3JqHsJbChoySQ9erA9V+xQ694Z9ij+MK6dST75QJQhb1wOEzhu7V+OpsyyojsaxdJA==@kvack.org
X-Gm-Message-State: APuU4Z+TWJItj0/d0reeXBx72Vib7QZ/IuNObFhkE/IObQiFleSBrc07
	VHBPvVu8hacd/ReCjW3PZ1VOP26h49UcsFRtXxKEefZQG4IMUlBNFCpVorET57G+1Q==
X-Gm-Gg: AZFdTZdIFuyUwg4pYEQotxsLQp8GaEIX+HBsSO4qcfeirKpnDt7fPVy6+cDM7ImpQPh
	PtH09Hm0rsC2xZVJ1Cn0UBMzPVqJqpLmBOA4uNd8HfDyR5YJH9JcDErbi4FCz5gSnL9iJsismtP
	fvFMGTdoYHf8/Lzzu3P04KYXmfLvRf4Za1ykBcDTsaPGojuZbcKrIjSXp3GO2FbUxgQQKoKi+w6
	hvamFi+p8OyIUw/9vOxXTQvHy4FuVwMeWrDLc05WgD/kZ9blVhWNPYYFcWPAvxbI1pcGpP33+Us
	6IFz1D0c9LTyZ21+VVeHgXV/jXETyw9kIKFVVTTJAIUpgfdIpMveDeOjuHYkeDRm/9RdBI+9Yzs
	tlzi3qe7M8ns3st3iQPd7edeRc2QCZiUv7drwNzJwiBy7+ypn6SrCsuILK2kn4/WfFilNItgvPn
	Jbsb2zKZTm0DOfsdID6xHAmBFlfdYLlNfzHQYJVlK9/+5tjSHG4wjm2BFrYpBueH5L55sgQzWG9
	Ej7YrsZecdb/R194klGagdKda+XHJEuFu5CLJ2svJfurSBWff9NsObys+awedtgzMjN1B3I+40i
	7z2AVYBDNrPMfnU4tyJLLZGt7IQRvopa/VMYOk4gn2Xb15z9gzsujSmS2VSKnW0D
X-Received: by 2002:a17:90b:1644:b0:3ad:47ce:3876 with SMTP id 98e67ed59e1d1-3b41c9a9cf7mr10724478a91.61.1795460825743;
        Mon, 23 Nov 2026 11:07:05 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40578d771sm21961682a91.1.2026.11.23.11.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 11:07:04 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 11:07:04 -0800
Message-Id: <DN2TQRX57C04.ZT5UUS6AQ1L6@google.com>
Subject: Re: [PATCH v11 00/13] PCI: liveupdate: PCI core support for Live
 Update
From: "David Matlack" <dmatlack@google.com>
To: "Mike Rapoport" <rppt@kernel.org>, "David Matlack" <dmatlack@google.com>
Cc: <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-pci@vger.kernel.org>, "Adithya Jayachandran"
 <ajayachandra@nvidia.com>, "Alexander Graf" <graf@amazon.com>, "Alex
 Williamson" <alex@shazbot.org>, "Alex Williamson"
 <alex.williamson@nvidia.com>, "Bjorn Helgaas" <bhelgaas@google.com>, "Chris
 Down" <chris@chrisdown.name>, "Chris Li" <chrisl@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Jacob Pan"
 <jacob.pan@linux.microsoft.com>, "Jason Gunthorpe" <jgg@nvidia.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Josh Hilke" <jrhilke@google.com>,
 "Leon Romanovsky" <leonro@nvidia.com>, "Lukas Wunner" <lukas@wunner.de>,
 "Parav Pandit" <parav@nvidia.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Pranjal Shrivastava" <praan@google.com>,
 "Pratyush Yadav" <pratyush@kernel.org>, "Randy Dunlap"
 <rdunlap@infradead.org>, "Saeed Mahameed" <saeedm@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vipin Sharma" <vipinsh@google.com>, "William Tu" <witu@nvidia.com>, "Yi
 Liu" <yi.l.liu@intel.com>
X-Mailer: aerc 0.21.0
References: <20261118223704.3286085-1-dmatlack@google.com>
 <DN0FL1752MH5.1FSZE620OJBM0@google.com> <awKlfqlQYhphXCvf@kernel.org>
In-Reply-To: <awKlfqlQYhphXCvf@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7826160013
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: na11ricso7kr1gjb4otygtofqed6bbeq
X-HE-Tag: 1795460827-510396
X-HE-Meta: U2FsdGVkX18crcBkZ2yCme3MnYkUiS7ehwHEOVUd8evED7H8Z2IItdCxZyuw4oqj9Mmcb+dSvp9pPZRXOPEV5I+sfTP5nocyYMLZhDKMJq62/rWTXEOYcvYIbRWw8kchhHgBADzkJDprHYUWC2cVnf9j5KRnMhweODoddnBoI0hTOqeRNOXf5I1dbr3nMzGBZM9m7/rtdfpUv5qnqqC38WyE74RqJRkt/2Z67SJqs0zl9/Skbb31xKVGFMdFsgPpgCM0igNVkh2xiUdnkvlnpbYmUkWU4dwx2qEtzIawy7tgLa+Ch3t9bqjbNZstVdjXPPmdfA+zrzvokkJKsN4v7UQ1LLSHayZSNJOMIl3WdMt5F0Ec/DGFIJH1XnsTflsn0zvXZYr98vBKexlG+G/pIRO5IGPbCJYGsAHqBMdWTjHSCbR+0QSF7b0Kk/2NXz+mdq2vYkOAmyYhNN6yZ3z8lUzz7vh7HV98pPHFy/uzRuRDwRM2VhXzm2SRZ/tBsnwJg8sKlxELY5u05qb2l9dTm1xrtVWr1Pdt8K1As/Wk6rOo3G9IHi65s/j+hf+EFVnfGJ+4N4EJhK1qp5BfzaVFZ5MwgKcwXsMW26NiYKoBjr2pb1ubhEj34uAHZFtnP1U3UuGbDpLayHS7CHKqHiqAMzZzF5n2w7Fs1gcU/K08Na9wCjJunZDfGeOOmdUAaBfEPMauN8OYmHXJx/uyMOjqP149G3T5UyfOukhGqPap55+MXKD2HFTuqM1PEMD55MYOuqfllZmpzU2mXnowMp+1cJ7kxx3/msxDxboQKfQk4FwIsbTvRTgBUACE20VcUSJxUhsO5Z8QUydSz0bYtMLO4w5kdtVn0yXAsWQABeszlAZkiA2VUCk7IgtR3mfDUX/E8HdCktNN/FIxajJq/5EvIQXjz5lhTcjvK0rj135TTQcyY6IqJ8DoxXgZ/FGiCE8DGlbV3tav/qxHOJez/2/
 oMvZ5eHa
 E/XfC6LESrUenQpSGKTOiJCYO+o4wsPbTiehboDXisf5Heh0pLwdvRGfMq5rDrzhrGw8URdehjdl1IfKvqOfcV6Qy2ZwxkQ1Fenn+xPwdJuWJHTU9SYZ2098fy4D+r2vWygqhHtKI1evO5smkhMfKWLPRWWGdTq0VTrn/4sUDkP+tLnFdVKfEOr/B0sJb9Ptmf8KBzp2/HY3QptN/z2lRZv0P900ksyGSHil5nepFQgGHv17OTWu1NsMprE5ycuVjIt48/HxWSb2znXfaKA50uFRcXP4sdHkRiubQ2NlQeJKPyFGHyA4orlhXpIPxNVXAmjcNzvPoJCiSuKrAN0RFMIpVLxahwKOwLwTr6+xU9yLatwc9hqkIvQaBBpgdOOOp8KaNoscM68PRVi+vG+a0hTCr9A7QcSyIySGG9k0OqR1Gp/brLrkX9B/RK40WWyfoPmYBKZhuTtPG6l4glCPVPOV8vX3TT8OumtYFysHEcwoizB6jNV8Nc70iwJaBWjYXhmqdGaakHH49nUl5XaHl7MvY16uEqDEdKM5RYbEHciauEyr0lBhwtNGB8f9llrjsKGR2s+BSBHWLNEb7ZV7iJFkQDn7ZD6k/6t1yN9agnJoPLxH9eYbuNddLQcM4nFpJlan+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun Nov 22, 2026 at 12:19 AM PST, Mike Rapoport wrote:
> On Fri, Nov 20, 2026 at 03:35:58PM -0800, David Matlack wrote:
>> On Wed Nov 18, 2026 at 2:36 PM PST, David Matlack wrote:
>> > Merge Plan
>> > ----------
>> >
>> > This series is intended to go through liveupdate.git, the tree listed =
in
>> > the new PCI LIVE UPDATE MAINTAINERS entry.
>> >
>> > v10 and a follow-up patch were applied to the lu-pci-preservation bran=
ch
>> > of liveupdate.git. This version is meant to replace them, and applies =
on
>> > v7.4-rc1, the base of that branch.
>>=20
>> Patches 08 and 09 have Reviewed-by tags from Alex now. I have a v12
>> prepped with some small fixes from Sashiko and a comment cleanup from
>> Pranjal.
>>=20
>> Mike do you want me to send a v12 with these changes or send separate
>> fixes for you to apply on top?
>
> Three fixups on top will do. Just please send them as [PATCH] fixup! as a
> reply to what you are fixing up.
> =20

Done. I sent 4 patches, each as a reply to the v11 patch it fixes:

  [PATCH] fixup! PCI: liveupdate: Track incoming preserved PCI devices
  [PATCH] amend! PCI: liveupdate: Adopt ACS controls in incoming preserved =
devices
  [PATCH] fixup! PCI: liveupdate: Adopt ARI Forwarding Enable on preserved =
bridges
  [PATCH] amend! PCI: liveupdate: Freeze preservation status during shutdow=
n

There are 4 instead of 3 because the pci_flb_finish() logging fix from
Sashiko touches a different patch than the other changes.

Two of them are amend! instead of fixup! because they also update the
commit message.

The amend! messages already include your Link: and Signed-off-by:
trailers from lu-pci-preservation, so you may need to drop duplicates if
your tooling adds them again when applying.

After git am and git rebase -i --autosquash on top of
lu-pci-preservation, the result matches the v12 I had prepared.

About the Reviewed-by tags:

 - The amend! for "Adopt ACS controls in incoming preserved devices"
   already includes Pranjal's and Alex's Reviewed-by, so no need to
   pick those up separately (b4 trailers would add them a second time).

 - Pranjal also gave his Reviewed-by on "PCI: Save and restore the ACS
   Control register and Egress Control Vector", which has no fixup, so
   that one needs to be picked up from his reply:

   https://lore.kernel.org/all/awBc0m4oW9nW4hgX@google.com/

Hopefully I did this all correctly... This is my first time sending
in-reply-to fixup! patches.

Thanks.

