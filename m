Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82075606A89F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zu/dJD9I
Received: by kanga.kvack.org (Postfix)
	id 890FB6B06CF; Fri, 13 Nov 2026 08:03:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8671C6B071D; Fri, 13 Nov 2026 08:03:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D256B071E; Fri, 13 Nov 2026 08:03:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4B336B06CF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:03:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36F51C036E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:03:22 +0000 (UTC)
X-FDA: 85430111844.03.EB058A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 93445160003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:03:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Zu/dJD9I";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794575000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+8Vs+Yp/t4sjNvb+bzKDikl2pLwbkyUE3+1C85nf6Q=;
	b=0+MxIPCdVgAwmyf6qEo+951pcdP64RWJ1tj1LMUcI5zDvVbyjYWafxbMF1aflr44XX69qA
	j+S0t+dz97i5NluFp00/bPD0xPx4g1OJfgHCY9KAv7SjvTTM6xPL8n+N4MBngkRg2+f6s/
	LZuvZT7GiiX18fmXz0krftUSE3SaV+s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Zu/dJD9I";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794575000;
	b=zDMk0nQTzTAMwDUa6ikxc7pm4lMrrR4ZUJiN/hSX4n/5A8K3gQtS+mAXK7abqjRVEW1PmG
	6m9djs4S+OoZUqPguRNpQhUbtrPPK4zaKErE9Y7Kxx/FRAtxvHcx2W+VDq/wo75lgcmNRZ
	Jl3R4FLHYalkiO9iljNsOhgMJmEvSBU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 961126014B;
	Fri, 13 Nov 2026 13:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443361F000C4;
	Fri, 13 Nov 2026 13:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794574999;
	bh=B+8Vs+Yp/t4sjNvb+bzKDikl2pLwbkyUE3+1C85nf6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zu/dJD9IxV2WuikZeXb8bfuCS4pFsvaCSWQhcqGCqyhr6faG7ezYtwzldCTrszp8y
	 OTPw5+vqWCMsanCAaNDu+XZ/OpEWNwtwQoGIappHXcN7Xz+uJD5pguphPmf9v+yFQU
	 3MtMreJ3DVOb1nz9k9PK9BarE0LZuMDvcevz+bgRdFWr4gQPC8Xx16dtyro89poApS
	 +aFXTjALkPX+yN6S3dS8g4HaorLdR97Gc0o0g/HMQ+8EeF9HETVOPLvWSqbzjaZZXK
	 JvC5zC3O3VYsv9PkUqlcEBlOKlMNrrXjPmft8TppMm7vg7Akm6eLeP6v1OpzM9fU35
	 zcl2BXrcHhXSA==
Date: Fri, 13 Nov 2026 13:03:13 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hongfu Li <lihongfu@kylinos.cn>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	hongfu.li@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: mlock2-tests: fix fclose(NULL) in
 is_vmflag_set()
Message-ID: <avcKibrnNmJn47fL@gremlin>
References: <20261113-for-mlock2-v2-1-f62195fc8394@kylinos.cn>
 <fb5ebeaf-2e3a-4d5a-9fb1-e86c1f10252f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb5ebeaf-2e3a-4d5a-9fb1-e86c1f10252f@kernel.org>
X-Stat-Signature: ij3b5ptcr6aj41aathstoaqoyye3q81a
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 93445160003
X-HE-Tag: 1794575000-813538
X-HE-Meta: U2FsdGVkX1+e2bMoMe5UGDYBybIkHD5FRNehJ+dL3ccjyX2kKrXCEa4B8+B5kn2p21kDcfRxI0ShrOq8yXvjJSgbROBWTSlh38bNXeZBtvhF/0RRLOnJs0z9s1koQYajDx/8WY6eOWJghRG2q7lqdgE5uKwPl6Sm8wxxHX8+8KNbqFqpmxjeFeol9A4uue5N12FmBmcTmhwe1esGp5Oj2NSlTC4wOPBhwV+zw8xTcvogDyNQ9L7OX61VKkyZdB3Zw1z0HH9DGHhOkrvIN4oHFmFPs2nrR8LqoRBAotr+gHUvnMR8AK6IQEXqJCs+MAn3ypu5CAByBRv4iyM9cM7Mge/C0fhiwSje7oylVlazyOIoc0ygL34Air9Lq7zlq+vP/hwl/Ro6RK+kuW6O8j0ZeKTMvS0+IVh4xtYj/CWlcizGtdsr0P/afO7TXcdF0YUKh55I9uKg9WzGozfCBzhmfk6pgs97pYB+St6MihQZmaGGUb6kKBXKa01vomb0CIWLqbOEggTEvbcHIJvi/DVQaS+UHSw8JRT/HpT9qr2YFJOFQ+jt8T4UWlycCOyHZ7fKh6upRlDwFSBTbwv6d1to7n7gDppvCxW/kQHN33V5RWMNkAkan8olaCZFb10jnXh6d86EGBaGzSeJdNETOUWCHIlPEPE4up7WiuMhkWmKKVh1Y6tC7VC/QHun/ymSoZjHpNSxR5WpykwrTLbXRm8dB8C8+PxY8vVp86FxfutM64CPJtXnGSOZPWW69Bynqw2dMBuan5H6MXK7jYrch8NtwWEs5ITL0Gox6miXsTIdqBidpXKqlnIbL6BGkPtXKmrqv8wuZtXoaHA2mNr6jXGBr4aMJgpR5uQLF1Ky0ZoRih58NmW8c48MrqepQKrlMtWgHN7FS9DStJ6GUEstgv/QwmpmBeRpERLA67HkEcLWRYiPe127u6fIW5L5xHAhAQ70BOff0TsSz1JmUeLrlaI
 To3CptCs
 MzjTpWiBihA+Iuh6L1eH54PPNOGVtG7AvCwUvk+xRzYSiTwR3on5QiuY5ZBWBvxrHnzNVbPX6VezpIqz7mBrpkodwbZlr/RP9M75eRg5EeHLxNvF0dZUcTbP19Utk6GxDGqVZ+yHH1snqPz6PkvjiinB4h843eBK0kY7NF1WPZB1WE3bvGocCOrlSFmicMJZ7oaboiEdtk/NI8fYPcaPm1AqJP/v6DPi5+OWbiXevsqyq/6DrtuiQN601NJjfwt2XuUawpCSW+qX0p1Gmd6xiFoaZelzEGFz+E3ua4zbqTJdIU/9/YFpXUqPrTiEQscaeq+ph
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 11:31:55AM +0100, David Hildenbrand (Arm) wrote:
> On 11/13/26 03:52, Hongfu Li wrote:
> > is_vmflag_set() jumps to the shared 'out' label when
> > seek_to_smaps_entry() fails. smaps is NULL on that path, and the
> > code at the 'out' label calls fclose(smaps) unconditionally.
> > fclose(NULL) is undefined behaviour, so the test crashes before
> > it can report a test result.
>
> I was briefly confuses staring at get_value_for_name() diff below. WHich is
> clarified below.
>
> >
> > Return early on that error path instead, so smaps is always valid
> > at the 'out' label.
> >
> > get_value_for_name() follows the same pattern. Return early on the
> > seek_to_smaps_entry() error path there as well, and drop the now
> > redundant 'if (smaps)' guard on the fclose().
> >
> > Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>
> Fixes: tag? :)
>
> Apart form that LGTM
>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Similarly,

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

