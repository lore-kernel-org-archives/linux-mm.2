Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85232CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5E26B00BC; Wed, 14 Oct 2026 05:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79D8B6B00BE; Wed, 14 Oct 2026 05:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3C26B00BF; Wed, 14 Oct 2026 05:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA2E6B00BC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:38:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31863C04AC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:38:35 +0000 (UTC)
X-FDA: 85320731790.23.41AB7E5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 96743A0007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:38:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Tb9NNRWk;
	spf=none (imf25.hostedemail.com: domain of BATV+79e2758366c6a2c139d4+8452+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+79e2758366c6a2c139d4+8452+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970713;
	b=Mg4JT48U0HMMODWkiV3mIJD7LbyFuWVIyz8GDMA/qy6DQ1MJ0qW+YqKE6kSUTmuuJ24FJo
	lhnUa3dk5h3UJKY0HQ/tOh5LN5p9Pq3JlBVh1aql+nSxtQGyMg2OAjDk3wTTfChWxRVh1H
	3uJGolHdb7FO/pPTFDwmg5LeKIsytLM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Tb9NNRWk;
	spf=none (imf25.hostedemail.com: domain of BATV+79e2758366c6a2c139d4+8452+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+79e2758366c6a2c139d4+8452+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=G9WavGOV+M27AHCktqdjmTFqaEVQIg+eVMixpUoHzZU=;
	b=Da3/KpZttlE248YfqyZ+2p6hpkWptZwMqbCYMoRdKTjtZuS9v3IfVMak/JYlagaKlKPWX2
	EJZiw5Ljm6aKiNiA9p4/frcLIs/MrrJ2qPa7vLaNjdP0hnXR2Z4uMoexsJTbvQxwSkpdfX
	wYHfnzY7jVries4aOEIKv3XsI87MnJs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:in-reply-to:
	Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:References;
	bh=G9WavGOV+M27AHCktqdjmTFqaEVQIg+eVMixpUoHzZU=; b=Tb9NNRWkCbbvhMvIHFAxUgeqaj
	SElv3u1R5s28qMRtUdyTFMuVhwC1FfrW7tzw2LvUXmd4Gn7Bu+uipHusGoliMHdmD1BagBfjpvuCY
	bTkU6OjGZqpX+LNIvktnMju9dVWH+nmIwlvTf916xRqCcgijdxrQciyS/0flB3TG8wVe9UgFM/Vv3
	f8ed/HcB5L6FHTEKcvlMC7aaKGdZHXZxPxqJsZMtCVQcAP5ySCi6JVV0h/fYzng6m9e4OFrQHLfvH
	nM5C/8pc7A2npMAGdhwXN3ZawmVjf1mulG29X1bfVv7VmynFZWkPxynpsW+CcQmPUvThncjUBeUeq
	4HM4BM3w==;
Received: from 54-240-197-227.amazon.com ([54.240.197.227] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGvQv-00000002Osq-1vv5;
	Wed, 14 Oct 2026 09:38:01 +0000
Message-ID: <41e273ce759f35ae18af394a072d5b81ed47ebc6.camel@infradead.org>
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
From: David Woodhouse <dwmw2@infradead.org>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
  Sean Christopherson	 <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton	 <oupton@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner	
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe
 <jgg@ziepe.ca>,  Kevin Tian <kevin.tian@intel.com>, Joerg Roedel
 <joro@8bytes.org>, Will Deacon <will@kernel.org>,  Robin Murphy
 <robin.murphy@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>,  Borislav Petkov	 <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin"	
 <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <shuah@kernel.org>,  Lorenzo Stoakes	 <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Joey Gouly	 <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu	 <yuzenghui@huawei.com>, Steffen Eiden
 <seiden@linux.ibm.com>, 	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, 	iommu@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, aik@amd.com,
 jacob.pan@linux.microsoft.com, 	gourry@gourry.net, vannapurve@google.com,
 fvdl@google.com, tabba@google.com, 	dave.jiang@intel.com,
 aneesh.kumar@kernel.org
Date: Wed, 14 Oct 2026 10:37:58 +0100
in-reply-to: <CAEvNRgEseLO+LbkwXrEit0H2LH5Wx-srSvHEMpt0=upPL3tF=g@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-QY2QZkBPV5msUx0Wk8s2"
User-Agent: Evolution 3.62.0-0ubuntu1~ppa1~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 96743A0007
X-Stat-Signature: 9ms5xfo1t5hiaqtxxy95rg8yibh54c7w
X-HE-Tag: 1791970712-947000
X-HE-Meta: U2FsdGVkX1+ba1wdULGBo7USpFmv6jUZrvK87Czf65GmjBDIRl3+zEj5tFrLPF9HTUJAn52K7LhhjQd6E3zlilGI/hcZkBbQ5boUK9K8Z4d+QMj8yMrmRbOqQ0wIjMyfDzgdJ/vNP7mW5qTjvZ0BXQjMjW7c7wWi0tTwSRRXWYFjiRku4x5hcsiK1jc1o87gjoiIo5uAoIZZPAHvFkplGgMqRSU5Ynt4rdy9jM42bwq84BxRWK/GloANrcLT7xpkgGCpKX9OiMCyqP46nURHVlTietNspaOcKCwdi8sByWOYDzB7Pc97C7NsP5sa3wXF9OLEeq9XRYwWRcIp15MHZqYFUUnV4odO1ECAO+FWYRJvS4WmxB0FP2k4ByQZ04Qnc+kucU21rPb2KOlvrSCxc39ofeIhqWL7YVxWw0AHe2/F6SCvZXbuDmCCArtEmxHGcvpCjO4WiXnPepM7c3HayDhUOCg5ozLqF7azqLr3wFdFqBXvDjbAa7BaCzN/ZyUyRIaLqv39b/D/Wuez19JvnGoHzCVZGBTDzOfCi1SS787aLhFpsh9NwSWRm26fucQPee2AMKqQh0lKfNMWyqtf9k0g2Jj9G95NWp0/89rhXnPcohFTynF9716MdzlyiFvzcn0mNBe7ov1RxCkaCs1eha+Jc6wCI/GlAXpV/zfeoBsSR24yBU/l/DE2ePERJx32pzLC8rk5r5RbfrZpFJGvl4HYfsFDvPi2sI1F6f/UA+4s2Y5yeNgc6SEublxqQA/juJ5kizld3Iw3A4XAI/XnEWH/Gg8SrvKz1Zrk7fa/e/ksNpoqDchzLDLeLySDnQMyh6+qXAGqa44lmURNXECRAA3100j9hqq4V+2+xwV3OqXnJ2RcvPFrmgrQXeiPFZApV4dXIQf6gyM/FZ0140+QfyOmyvAuL+OsXQZ9MhkUpE+FElg6tpSBmkFzu491OprzHRyltjTQK2gHAYx8Ao6
 mZKhPrF0
 QL5bV54/NDCsn6ZRJlLT2PYqb6ybGBhQUpY9+XTxO0eaojNkEPBtRSWg003R6auNByOHZLGGRb7XyUvgj4utEISqbx6/PSpRutez0jZMU+B8EKEIim1su8KYid4cAjj9biMISzhKSS3DlaW0vV2G/qYez07d7o2buXD7IOa7X02sw3UDC3V28lwqttbVEMRLHBEgyrKjs3v4JJ94LQL08VM8Z1Fu8BhVeK8oSmNssW5VxtIqvP4Xkion1ZfvcvPqhR+UbpfwZldkXJkvA4+2EP9ObXqF7Rh8iz+m0kAx6KFp3c7FNqNMSe1l9OHOX6bQLRT0OB541ICITILL2xvrOrBIqtgLfRH1or/kj0x/lxuLwRRRnoXGRjTKsKKIS+0btz9SBWBdDlk7lhvbUt5L3eMQB4JlApy4q2UqRSkOz17QtHTaTPULs4EJG3NLh49H0S1ZgI0x2KMHa41I6BDU5dP7/68ZHk2R3jZgr70d8yZCFR74Z/h3vYFkdiQo5C189GWpXrBJ1Pp6pDrVOcBuJLtf+rpG88GYdgLLbHrtdKzyCvX5TpjIw2aoOBJoBaqDWTiInwt6q0lx3ccqO7lnepZPxueCnk/2Ompdv2KFZlwlk8zqKBWeZynHmyQUpO9VsiCimT/g+BE8kqE5SEMnWGkT/OibCTWbUX+4THwWQEINkOnCtkIooofK9U0icR3FgGp2Uas8ExzgySSjzRR5G13+Gr5oWFb40wR+fCDuY42u4ruQfoz9cb/DfnJJ7qJN3PO4lLzAWY5SuhM/ab0opv0fL/l+Ng8Fr6fGlWz4eHldbqpQ/UxT7qnh2Fs5+zvxfAvPXBJoLNckqh4W9TlwdxMRJVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-QY2QZkBPV5msUx0Wk8s2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> In my proposal, I agree with you completely that the provider must be
> allowed to revoke memory. Using the sample in this RFC, gmem_fd_ioctl()
> called with !GMEM_PROVIDER_SET_PRESENT is where the provider wants to
> revoke memory, and the revocation in my model would look like
>
>   [PROVIDER] -> [GUEST_MEMFD]
>
> and [GUEST_MEMFD] would then fan it out to [KVM], [IOMMU], [USERSPACE]
> and [DIRECTMAP].

(Fred is the one with his head in this space right now; I mostly wanted
to get the ball rolling from our side. So if he contradicts me, take
his word for it and don't necessarily wait for me to concede.)

Your model above works for me, I think. I just don't *like* it very
much.=C2=A0

I had a nice clean (in my head) model where the memory provider is the
owner of that memory, responsible for who owns what and whether it's
read-only/shared/private/revoked, and for persisting it across live
update.

Anyone who wants a piece of it can come and ask, and it interfaced
directly to KVM, IOMMU and anything else.

And it was then theoretically usable for other things, too. Fred has
already been working on ways for a guest to donate memory to the host
for caches to support more efficient nesting, for example, and that
could have used a memory provider (which, on the back end, has had its
pages donated from the guest).

The model of pushing it all into gmemfd probably works... but kind of
makes my skin itch in ways I can't fully express.

It does absolutely need to support PFN-based operation though.

And one of the main design points is that we want to support the memory
provider being the *trusted* arbiter of who owns what. The provider
will be the part that gets the most careful review, that some people
will be suggesting that we write in Rust because it magically fixes all
bugs. Where in some platforms we have EL2 literally *enforcing* the
fact that a rogue Linux kernel *cannot* access the wrong guests'
memory, the model we want to support here is the next best thing, where
a small and trusted piece of code provides and revokes those PFNs.

As long as that's preserved, I guess it's probably OK to push more of
the coordination into gmemfd than I had originally imagined.

> Does your provider need to know if some memory was transitioned between
> shared/private states? The provider can be notified too, if
> necessary. If not, then isn't guest_memfd doing all the coordination
> better than going via the provider?

I think it at least needs to know, doesn't it? If a guest page is being
taken away (donated to another guest, or something like Fred's nested
cache), then we do kind of have opinions on whether it's back in
'shared' mode or whether it's still allegedly private to the guest
which claimed to donate it.

--=-QY2QZkBPV5msUx0Wk8s2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCE8Ew
ggWvMIIEl6ADAgECAhANkOKMSmGXhF5eMl0rsRhvMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBHMjAeFw0yNDAzMTMwMDAwMDBaFw0zNDAz
MTIyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UE
AxMxRGlnaUNlcnQgQXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTCCAiIw
DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOfSIeC0vv1xPQ+dgSxbIIrkaru6skAWJYaGFzmv
q4Kq+2wU2jxhcWlJg/JeP5jEkq/LM3pn5aaLao79j+XRmS7J1ZpJKUODJVoM4s9MQJhTMvo4qS5Z
S64g6QR7Obkz3I1Lr3aWeSBmDDEyzue+NKtuWZ1Cxy3RdXo/w5HgRc3l2AercOM3Gt1XonTzEtTb
Z/Hwc0Sn9Gz8RmGRK6Ka4hVDl8q/2l110KaV233Kh5etP0csXS8MIMdVRfRu3sc5hp13DG7lCKzK
72a2GEpI8Wpl26G6I1/LMzz/98T+FqjTqxsdquk7Cj7m2vKGLW1BorpQH7WFGPdJQXJe1hfbfiZA
CcVdCtl4nAacFacmsiArZBfX7AQGL7isvHUwwYFEtcApyGW4p2Lt+t8nvU0CANA6BHOpOz1xOP8W
mAESbUriIjyuTUf3fJ9oDNCurVqhASMJCDaWI3lYX/QAoiAzt6akqbbZxo2ujW7mGGqc0KxqE2cs
h2T79v7pC8aUtHBfwNrTR19GnZVxE0eQ7ViIQhR6mpSaUQFA9sG+cmD2G8TnCgYsLa0q8De6F61a
CBevQGHNzrbZ3JAMneveYg/Jy1XxQHDRcvrMfWKe0jjcWbdKYlaGVPm5V1ILwYz7Yv5ewo3NUrxI
GJiywe9qPhuJSDZs7VehTuI0FxGIsgKzVjgbAgMBAAGjggFcMIIBWDASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBT3m6JO05fF9DQPQw6Bhc6RkzKv+TAfBgNVHSMEGDAWgBTOw0q5mVXyuNtg
v6l+vVa1lzan1jAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMG
CCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
b290RzIuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdp
Q2VydEFzc3VyZWRJRFJvb3RHMi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUA
A4IBAQA+b8Uw53sDspdZgukU+qzLyyHkcjlxGGhHlP+zrmDLKm1wEFvCRS2pili3Hy67i8N4N5NU
vw5Rg6kv3lxb9S9Rktxk43k+tvm68pl7OxQE55ZjVY87P0lUPGwEqOOwLLyH02ZQcsfq5p5LrOH9
0JvmvZ1yy73HS+VpDAqOlytE0NSvTIRqFFkKQGQwfjvtql9YflujuNNvJztjBaHKYZsnNSg+J38o
jYq4TP3pSg3UdVH0PncVjPQyqxC9xef5Xae92Kbkzol3x7Nel3A1bwAkalrDMspvTHvey6LfiBks
FIqviTnoy7fgjaRAJgHS+RXx/cmuRd3rUAclSVVrYu8RMIIHAzCCBOugAwIBAgIQAzUotrsybJHx
HTjKOIVdIDANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
IEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQg
MjAyNCBDQTEwHhcNMjYwNzE4MDAwMDAwWhcNMjgwMTA0MjM1OTU5WjAeMRwwGgYDVQQDDBNkd213
MkBpbmZyYWRlYWQub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2pYux73kdbYX
sWF8f1u6DJP91qcqaZetsyfPkZk0B+MmXmAEv0kVes5n15V2mbDThOnpoPFly0UugQO9JYqLfrtD
tKD5yL58fgrDB9Dw+LQikgrHafl6YSCds5AvUu/8hw2J6noKrcOLJpKlKn9Fl/4IB9Q3JIdLx5aa
EtTqMalIPqHFOlgrJ7s+aua8xbB8YQ9ahqYBXWRJNv3P/2b1DYtdrz1oqZPE3CcB8Pc6Gf2a1Tcm
6TAgtEx7Cf1BFcrsrMz7TWHmGQITieNb2r9UYWSc2Gp+GtYFNJCgT0JJXKUBIauPMKBLteYrL8Fo
ff/uY44dC/mDWjdCP/5x0qelPQjlBvWdHL5zvBTOj06rJ0m3HNI/hnIcDh0Qu2j9reb9rLVcdym6
bWmBM4uDEB8Zv9Ph0KTBFSy1IosyakuD1j1Os30EzjGfbi0EUXIvnOcYbTBAbM5UAzrxEHMhBvoX
Pvnx+OyvjJmc9tWxTX6AcSz+m40esbT17URBeZS18afgieiikm5TynlUYP1LciR3hSgGVzvGXnKO
02VDFR5itGWdRKZ2W5wIShNfWfhSa0D0K5UdIDt5Qc7sjzwK1Yb1sY5Tu0uA5mhIS82q1ov83uxB
sFkriNnhGv/M1NCDVLBiOMsHu73qUM+yKmgKLwF9Hfn9WI25glbAMI4S5r3hYzcCAwEAAaOCAfcw
ggHzMB8GA1UdIwQYMBaAFPebok7Tl8X0NA9DDoGFzpGTMq/5MB0GA1UdDgQWBBRcYhqbcGzn1jrT
JOZaB8O7qllDpzAwBgNVHREEKTAngRNkd213MkBpbmZyYWRlYWQub3JngRBkYXZpZEB3b29kaG91
LnNlMBQGA1UdIAQNMAswCQYHZ4EMAQUBAjAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYB
BQUHAwIGCCsGAQUFBwMEMIGpBgNVHR8EgaEwgZ4wTaBLoEmGR2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0
LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsME2gS6BJ
hkdodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZT
SEEzODQyMDI0Q0ExLmNybDCBjQYIKwYBBQUHAQEEgYAwfjAkBggrBgEFBQcwAYYYaHR0cDovL29j
c3AuZGlnaWNlcnQuY29tMFYGCCsGAQUFBzAChkpodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
RGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZTSEEzODQyMDI0Q0ExLmNydDANBgkqhkiG9w0B
AQsFAAOCAgEAocabrh1cPd5s3vY5rnlBVQSTc7zs2ZWs67dAIltR+05WELrYClVzzUhMs/LOJPlr
EUo45UDDomXq38DxFepaPd9+iNLjXfn33EX/IG44j04lU/oF/Rg9VeQILkYLbCZ/x9wOjNHZc4SN
ydY7Dhvf/sT5aBz88u7D5+azZJ7Qf1U57wYseCH1Mt0nDrtr5y19IJ8D9xJJ33RFL6vfpHZBBAQ8
+3RqkKNxLoV2aFvQhxdhjNLDqTv3LjUIdicwPraN7JkxEu7CV2Lka7eRqJgkWL7SK0YmBjGpRafs
+icP/ON5RCCKTTb6VlX8eTG2sJJfsFhvJNCCt6xexbWzWtIrfP7NvPBvwBB737AyEGBZkS5aNizT
McURJGTv9UKvBh1LF/+tNhYtLvPCN7oecGzhCHht9jcwSkygTo3Y6YlK3QgOu+ncmiBbfeuwlLZ1
LxbYvG6hgNqXv7u6YyADbYajAQJXJ2OQen39pm3Q/AQSyLYG+B8lDglWsM8tYXPlEdrYJcksGK6F
nqIX6Bumn43rBooLJdiZp4WmfWdL2pxe+LxRDjprmqu1WprixDxULSTOKJZoqTlugs6y3Bc+if+s
gHnBBtz9WQ6MtPHkh7zONDAFIKcBmv8OqPQCx0F3Wv3OEybwMpXx0OsKgK8wLldaX1pXcMuyDgTL
Sqs0AV0OHUgwggcDMIIE66ADAgECAhADNSi2uzJskfEdOMo4hV0gMA0GCSqGSIb3DQEBCwUAMGIx
CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UEAxMxRGlnaUNlcnQg
QXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTAeFw0yNjA3MTgwMDAwMDBa
Fw0yODAxMDQyMzU5NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZe
YAS/SRV6zmfXlXaZsNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2z
kC9S7/yHDYnqegqtw4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qG
pgFdZEk2/c//ZvUNi12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41va
v1RhZJzYan4a1gU0kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0c
vnO8FM6PTqsnSbcc0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PW
PU6zfQTOMZ9uLQRRci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXt
REF5lLXxp+CJ6KKSblPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQr
lR0gO3lBzuyPPArVhvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7Iq
aAovAX0d+f1YjbmCVsAwjhLmveFjNwIDAQABo4IB9zCCAfMwHwYDVR0jBBgwFoAU95uiTtOXxfQ0
D0MOgYXOkZMyr/kwHQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3
bXcyQGluZnJhZGVhZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEC
MA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwgakGA1UdHwSB
oTCBnjBNoEugSYZHaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZEcyU01J
TUVSU0E0MDk2U0hBMzg0MjAyNENBMS5jcmwwTaBLoEmGR2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNv
bS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsMIGNBggrBgEF
BQcBAQSBgDB+MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wVgYIKwYBBQUH
MAKGSmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNB
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
eLMyW59kgB+bqGNwpow65jgAAAAAAAA=


--=-QY2QZkBPV5msUx0Wk8s2--

