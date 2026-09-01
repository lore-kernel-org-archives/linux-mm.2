Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9547EC624C6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6AC6B010C; Tue,  1 Sep 2026 05:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE3C6B010E; Tue,  1 Sep 2026 05:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3E16B010F; Tue,  1 Sep 2026 05:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77AD16B010C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:41:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0AF9CC0380
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:41:13 +0000 (UTC)
X-FDA: 85164700026.28.6E3BC8B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id F331C180002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:41:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=n6CXPS3L;
	spf=none (imf06.hostedemail.com: domain of BATV+fcddca146e1c445db929+8409+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+fcddca146e1c445db929+8409+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788255670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DKfAT/5Gh3ezBw4rtq47DlTGyzXjt5OlrIPWkHdiwA=;
	b=t4D5+5P4ncWg8oX6XG7VjZTQ/iKcdZWMrfh9KZROGB3S7JpIoxCMdexHkqvzaC7DnrIDyX
	ByocEJi52LJva8yfOtbzSgN5oJgD5kRk+Ai3ho1uDbbMsCA5Uj+qDoLGcs+F0CsefKjPah
	m/FygVV6zKJJRkPTL1JfJnjX5UNRKxk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=n6CXPS3L;
	spf=none (imf06.hostedemail.com: domain of BATV+fcddca146e1c445db929+8409+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+fcddca146e1c445db929+8409+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788255670;
	b=QBpC24vHtS5ph2aLt4dro5zeFRRBYYNjOq7iIvqoK+QzKUk8xLOLfZp2iO0sBunmF8LlCh
	ilfDKbd3Q0lchZXLacKJFEuC9KAsASYEPTtBJXyzCyWLG/qa8qhXmNAHQBVtRW0Z1FZ2Ar
	d51tbzqc1nuoKaLY9ilVV5ZQ03/jwS4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4DKfAT/5Gh3ezBw4rtq47DlTGyzXjt5OlrIPWkHdiwA=; b=n6CXPS3L4l5Iys6BszAvoJ881C
	ZAOJb8inC3slMaxLmftW4yu+CXBXgJSMcjwR7IIr80aZSRf/9MWcH1vaYGxJWxBnPiZ27FbgxEJ+F
	B+mz96odEB1fuSM73TbHfSdGSvhgKJa4BZBoPqXseAr4J78M07Z0R2KetRbdMINEiFM9sLfgueFaV
	9DM0yLHj483zY3ljk2Tbei/tFL7MRQvTOrYrSjJVnfB5+rfTCcxw4mK64pJEOKLtJfWD71pp0H3JZ
	/3eSZQKzXPIui9eBegTSgWr2p41bKdz3g81U/UBP+Cqz11dok/klWvbhptuzc2VOg1nN2fqnvmNGD
	YnVopuUg==;
Received: from [2001:8b0:10b:5:c2f5:a84c:7d8:be7b] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1KzC-00000004rSp-1KfY;
	Tue, 01 Sep 2026 09:40:58 +0000
Message-ID: <8cd4aa65b1b499d4c614aa4cba445b6aeb89acf7.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: paulmck@kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
  Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton	 <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>,  Clark Williams
 <clrkwllms@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>, Jerome
 Glisse <jglisse@redhat.com>,  Christian Koenig <christian.koenig@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Date: Tue, 01 Sep 2026 10:40:27 +0100
In-Reply-To: <90d91673-a912-439f-98ee-e43285294486@paulmck-laptop>
References: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
		 <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
		 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
		 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
		 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
		 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
		 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
		 <c39bda52f4c1573193aed39246f0d705755143fe.camel@infradead.org>
		 <90d91673-a912-439f-98ee-e43285294486@paulmck-laptop>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-2gSsVKfdWwq99hspFzjf"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 9h4hsp35muz37ganj7g5c4dkci7zj6qg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F331C180002
X-Rspam-User: 
X-HE-Tag: 1788255669-262775
X-HE-Meta: U2FsdGVkX18ne9/Y+PWx5lQhCZ2pEjRdzAhsJgWmgk3Cdb/lSOZ4K3/9fr8cUzKtUjTH1mToQkbDljChF8p/HdoKVbMJri50ztHwEwYn5uqyg942dV5p6+3XkVzsia5bov4+fefnedJxXzle8DL8SMcPlJv9qMCnJPPkDl36CQ5vSTOgeC2k4wQZM5UBdw5s8vUAXY0cgNq4ZtT/+1WaA9HVRb7A9or/DreADPXpryvnNRKXq0ILr5XBVbVdS1UTUkq1UwFFX58qfviAEF9v99scM4hJgxPY3HnJxvU/wCA9/dFPL3/7k2pxEqSNjt8nvAAsjcnggBtZo7W+z6yf3XLTN83QJNuzk3QZxN3i+YDh7MK0XKFWIqIjTZIj/tVTj9iOeKH2SzxqXFA4sC+Rq4sg1pjRMw1T8Q+B2304zHAjmvuaKFHvdahz/KJBXfSCM4D6rwMPy0FOtfAKJ20A6DROfW+X3SAVhXaL0A0810MEbQjBF0Qq3Fx4RFu4f2iWkioMEs30rTobliqTAQF+/qbzlLh7JT8XsPPETiP9/QfCWhRsSDHfLu9BgEvxMxlHlvLNHHLQ1Mj1iMOjgN9roeMYttBkVHwJI5B8eze6KHdorkNqvB3Yzizth93Q+1zixd8IKx1B9egrZq866OQRGIdJEoWgdhStyTh/xQz0syCphJCRID3NqmldXd4V39b808FHfKqFsut4uEkLd2z1Bu7l2xVrKi3wpIafD6ZbKoZFCJyDoxTMnQZ6QO6c4oojmOlfDygVpu4NTe3OiMF7vFWlaCegHTZfQ9ObBIM/r9/EFwxxbPHjfC1ezG69zdhdOi6KTHiqVD2NBkQ6aNRIoMtIGsYjxejAzoSq7JVXfY6l5sT6W95BimSOC88gEzndm/RZki4rLxhjGGlr8I7b0ZyQUzib2UIMHTMNt17gSv0EB0u0uiN/WymtXjsHZRlwvzn7HxM9afTwJzLy5D8
 7mtD921M
 BnPIC3HxSxadbeu4Qi8ZfphzutH+iiXR5IuV97BpERhW0Xdrrmz7O573+wIH7DTvIfDL6XFZ6exypgit2HadxUtvOWKG0VRgdvNTmf5fGUw+Uu5MsbCiBaM184TzDkPVb1fBKYlzBZKYhZfLTgix2cWYxKxUIYYm0pieBQQKiiIDkjgvdjrCggk8yy5MkAdlURiqMzeFUwd9EkARvV5QwzKGdfm64TdexAM7KU/P+1xJ2wsfBK0MTRXr1Pdvg8lXQeOJub7rHMdmS2mqbA3RXH/FCzq/ijEtiVoRcYT4R/9Hr1a1gZqQRzqHfsgDjJ+CpH6HdZP72NE/3suttrXb/UyMwGAI38pWYryxxmKyQF+kwf5OB5Qs8za0nUNKDzTYSlKVOHy7FBi/wgPn2YwKVIQRnpnyd8+vUx0iVBKW02GSnu2mfKkNMX1/nKQTWYdGzPZTGI8ITb8rP3lDtE9sdYXU2mmagNBqpw4duY1qUfhRhPYQiUeu4ZAudTuLVdWi6x9Of9oTt7CaPviZQUiwdemgf9QQ2lhEKYhqWPeWMHWLigtT34UJPANHTouifppnIz51trZU/Xj01kgR9Y/oRmYbMRY1H5m4QN3+6SztIFkciHnQU62LGzkRWE97UXwve7vedwHM8W3Pnc3CYr1XK5uTh5PAOpI30DENMMrBKwwwDSVwHpO5N7BDhDXCW8AnXdDswwnHjtxmAkYBU3P8Eu8GMM8lXU1jbFOybqh8AdnhvAacxm0P4u/R9KcawpX7zEIEmrPypRbiYhINXHac3gd5fxI6gqA/vW1lFZRCkAtc+SPGL/134qrWilvY4qPmWu2nA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-2gSsVKfdWwq99hspFzjf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-08-31 at 17:58 -0700, Paul E. McKenney wrote:
> On Fri, Aug 28, 2026 at 12:25:01AM +0100, David Woodhouse wrote:
>=20
>=20
> > =C2=A0 * 23f10e07aba3 srcu: Add try_synchronize_srcu() for callers whic=
h can prove readers absent
>=20
> I do not intend to provide a separate API for this given the possibility
> of indefinite postponement.

Makes sense. In that case, calling it internally from the 'right'
places becomes important, as the callers who care can't do so for
themselves.

We discussed the fact that synchronize_srcu_expedited() will also want
to use the same fast path.

I'm also looking back to Sean's call_srcu_expedited() patch from March:
https://lore.kernel.org/all/20260309193059.2244645-1-seanjc@google.com/


| Due to differences in how VMMs manage guest devices, and in the
| architecture being emulated by userspace, some updates trigger call_srcu(=
)
| with concurrent readers (i.e. while the VM is active), while others occur
| without readers, e.g. when configuring devices during a pre-boot setup.
| For the later case (no concurrent readers), using the vanilla call_srcu()
| is problematic, as it can kick off a normal grace period (totally fine fo=
r
| freeing the object) and effectively transfer the non-expedited grace peri=
od
| to the upcoming synchronize_srcu_expedited().

So the offending path uses call_srcu() and triggers a normal GP, while
the victim calls synchronize_srcu_expedited() and gets stuck behind
that non-expedited GP.

Sean, if the victim is the "no concurrent readers" code path, as you
said above, do you think the fast path in the victim should suffice,
without the cost of an expedited GP for every bus registration?

> > =C2=A0 * 2a55908bb12d srcu: Keep a spare node array so srcu_gp_end() ne=
ed not block in reclaim
>=20
> This should not be necessary given that call_srcu(), synchronize_srcu(),
> synchronize_srcu_expedited(), and start_poll_synchronize_srcu() are all
> ruled out for atomic srcu_struct structures.=C2=A0 Thus, there will never=
 be
> a conversion to big, and thus no memory allocation.
>=20
> Or am I missing something here?

Agreed. I just didn't get round to dropping it yet. I'll do so.

Thanks again.

--=-2gSsVKfdWwq99hspFzjf
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
H+hfy66i0Tjedf31J2ZU0LsAAAAAAAA=


--=-2gSsVKfdWwq99hspFzjf--

