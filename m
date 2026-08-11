Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD01C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 09:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70ED36B007B; Tue, 11 Aug 2026 05:00:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6396B008A; Tue, 11 Aug 2026 05:00:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623416B008C; Tue, 11 Aug 2026 05:00:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37B916B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:00:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 26FF0401A0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:00:17 +0000 (UTC)
X-FDA: 85088392074.06.FA4CEFD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 106CD140003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:00:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZESC1Krq;
	spf=none (imf09.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786438815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I14e3TrpPgGVP7xQq9yv4x4i8cf7y8ffIFCCwueJNXQ=;
	b=Fmjo6pDC0vGL9ev+nt0qSREsiBbO6NxB5Ul8yuJq/OjBsz90fvdUzZU9t536HIUdYwE98a
	3Z2xa0Du18XxbXAYiMWlBoo/F0WET+psm2uUetX/ROeSU48Xfj/ObxKQ32J9Oe8qu5i5nE
	jqs8Dsyhk2P3crsTP+4vuu3vvqhSEXw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786438815;
	b=8OU5kKJfjn5oa8l/d7tJ9wdp0ruP4OwEV7IDBBMUl/pbuDLkV10XUQ2CzeTRykZHVUI9PX
	csFoWo2RK5+aQjLllu3UhNEuljXMjeI41x5Y8xy2kTNtQ71Y5unS4VuyTT616WmVfuHlHp
	dFaYq+PfUWgeNCFvmmGv201ZnPhES94=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZESC1Krq;
	spf=none (imf09.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
	From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=I14e3TrpPgGVP7xQq9yv4x4i8cf7y8ffIFCCwueJNXQ=; b=ZESC1Krq/xm/no706gL9KG2CiU
	Xh3Gu1P2T/RdZPeMvDSICN+Cn79ixMDTf37RRQH1awSfJs2L8PbIxt2eotx5pPcaMyJAyoCT/yxcE
	7GKq3c6GWNrFOWhJIxgXOJ0X/wWrtlpfypWLDtV8WhRyr+5TGXVl9jUbYBEort5+Jga0WxFDOdt8P
	pKSagFBvBshAdSLiL7Ul0PQUGX8zmQr24KG8mBrMbWSEgDdM+pvUSrSoO78+4g9pW+r5aNOaCO+9R
	PmfTFQX5sAM6aRlHwJiVslFgX9J1ml06VnSBzGQ1zsdarOFnRGNEl+cj3fxc0Ur8kEA3HVapEi0Lq
	pQBc/+tg==;
Received: from 54-240-197-227.amazon.com ([54.240.197.227] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtiKG-0000000FG4S-16S8;
	Tue, 11 Aug 2026 08:59:12 +0000
Message-ID: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
Subject: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from notifier
 invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett"	 <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>, Sebastian Andrzej
 Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Simona Vetter <simona.vetter@ffwll.ch>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse
 <jglisse@redhat.com>, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, "Paul E. McKenney" <paulmck@kernel.org>, Sean
 Christopherson <seanjc@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-mm@kvack.org, kvm@vger.kernel.org, 	linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Date: Tue, 11 Aug 2026 09:58:44 +0100
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-0ndT/EUD6WjSKs4Ijo6g"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 106CD140003
X-Stat-Signature: hygia879ydmotf5dij8zie9bjec9yeed
X-HE-Tag: 1786438810-616839
X-HE-Meta: U2FsdGVkX190ituZ7lp5dHOBlaWQ6AywhAxBLlfuMcoBGo0i7Uod5iUSfStwKrAiXzAc28OB1Txitx9BJekxWXUvVDeHCh9gsNyMa9EdOwyRnq4RZ1As/oQhSWfWsaiQ9u/FxWmu/Qpr4WInVRj1Nw36VXiJI+Jv3u4kKmlKUyh84clyAUHWlbAb4dll4GldoveBxg/xI22KjMi3PdVbsZio+qoGFl3EK/z0K89LYm1qPOlwnP6oO0YxyoY44C4jdnX0KMPfTedAF5hrqdNQUBvl1qbKLMItb62HtcOZyTDLeWHK+/LjzBaAyAotCYBICL0QF7NFUNVt3Ac2k1dHSRR4xIuPJBz3gVqDyfSaBI6xkW/UqQNKHiffj0sF6T/w3SnU8eQhUh68/h/zxfJdSK+Kn+7JlLwXjwqFhUM+a6aaT4WDOlGrKVK2LBOe6qVm4OrVMF9w2kqzqDtPte9MixqDiq6PurkW7E2t60qI1C112wK5sdXE8S4ue8kCqGFFO0WLzRb2jCwhqnz8Zzaz3wRtm8cifVyMH0Qe/mlbb1/6gvbW4hU4UZyK8zSwIwNmkZuB2DbuOaeCTNy7MFIxwlbNdtB4+VW85h1BbGeAkvGe9EWeaXrnjfhVFdnLqy/o1zsGArEIjayvDihkLdM+8xmvaXXYlYRrw9D++s6juz+XzrR/7f0gxOBUIhip6oCo+4aF27EMJwydhjH1asq0LEyLNm4dE0BdZb2t4oFty+yutFBTIjXIZXGHe9TKTIcJSXcANehotJd0eEXkcT7xnvU3+7fObi1SXG3Yp46CpAVlNPIcG9ec8SDpSYkKxhyEsj6xhr8ezEYHqnFZnCk5PLiI4toH+Hiia2rSKSeGjSn3XZTO0mu/lOhPcLPjs1mEcU6DtCon7JQWjg2m8UUlYlFMjZok7mJ+uLqbiM7t67VaPSkzGWElaYqrHr6Sxumg1tuxciU2Wmfvpq1hzj0
 WkRSjD19
 cS/v4pcpaf6LDaQNlyAxgrOBGOPGC7lMr24wsMnep4NYTdm///2Fhw/gX0GPP9H8szPGI8s8eI7qk73dGLYLCENcjPy9sg4nR5vy5yAqccxlJ26pAwJcPSCe7uf4SL/PnAOH5nrwJghMAmH0Mae7x8/uNXBDM/LTdNke7eP8dT+NprZwGfBu2od6Txgg+30S5bfnTiJsTx6Liou3YauTma+hDorGvDUi1X5ov6OTrUKBEM1F7Q9nCHWas6nejZdqpFzvKXmkpTpu5LBn9JRVHeKoOK8+f8zozYkz1U3ibPV5tOlrzQAg7NT0q8N+YFmUhG2N/8JXYtVjMianDMI0UTWqkQcoWkFl2kLLDxs5LD8ret+zKP3PZF2S/vsAj6WkCrUU/KPXAIb+tIp7d8XVCG47cPrraFVC+c9Wb/w+Bpv3AESKeW80mNfn+4JwPge3o+F+tS5eFRVbA61VT02NHiw2oON+/f9t6INrWCsAAHZbkmJ8Pbyw84hldYEx8d1YvFG1ynnnwluKr/Yc/xLwe5FIsG60bVRyocW3SX1rDuOqpMX6FOpgELqoZZTsGFnoxse3W2euc6Iti4cP0N98IyDKmwGZag60a5Is5hpqGpbHyGHTdxjXgqYiXe7Fx8wZBdrOhHuVTUf4LTc8h1mvVpSn97rr9DKI80IMPbAsVIXzdaBV8FsEnkzjJ5ycrao40rL41KRAfv60Tsg13uDh6385UxXRD4vqmK4eR69K2GEyR1CSa+hqdqCf8eb8eLGRR/ROwUFGXW+VJvSiM1dIFZPgLTd3UAzwLx0TfGnTQAUUOXL0cSl2nyrkJ+CU3GdUR3dOD7gHvC8d+P2w7MQNLeBEX1MdhLao5iDgG3SLc3nET/YrrUMxHKoI2RO0pSnpVKCyZdKYZdnjvO6tvBMbwv7/9luQfgJWO3DT2njr+IxQYyU1BHIB0T0CMEkhNqBi0eC/f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-0ndT/EUD6WjSKs4Ijo6g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

This effectively reverts commit ba170f76b69d ("mm, notifier: Catch
sleeping/blocking for !blockable") for the mmu_notifier call sites.

The non_block_start/end() annotation causes the scheduler to complain
about *any* voluntary sleep in a non-blockable notifier. But that was
never the actual constraint. As Michal Hocko put it when the
annotation was first proposed (quoted in commit 312364f3534c
("kernel.h: Add non_block_start/end()")), the OOM reaper "shouldn't
depend on any locks or sleepable conditionals" and checking for
sleepable context was "the best thing we could come up with that would
describe these demands at least partially". The real requirement is that th=
e reaper
must not block on anything which may itself depend on memory
allocation (or on the dying mm) to make progress =E2=80=94 which is why
spinning locks were always considered fine.

That distinction now matters in both directions:

 - On PREEMPT_RT, spinning locks become sleeping locks, and perfectly
   legitimate spinlock/rwlock usage in notifier implementations (e.g.
   KVM's mn_invalidate_lock and gfn_to_pfn_cache locks) triggers the
   splat despite having no allocator dependency whatsoever. This is
   reproducible today on a PREEMPT_RT kernel: KVM takes
   kvm->mn_invalidate_lock in kvm_mmu_notifier_invalidate_range_start(),
   and if the OOM reaper reaps a KVM process the result is a "BUG:
   sleeping function called from invalid context" from
   rt_spin_lock().

 - A notifier implementation may legitimately need to wait for an RCU
   grace period before allowing the caller to proceed with unmapping
   (in the manner of a TLB shootdown, waiting for readers of a cached
   translation to drain). A grace period completes without any memory
   allocation and cannot deadlock against the reaper, but the
   annotation forbids it.

Checking for genuinely forbidden dependencies mechanically would
require tracking *what* is being waited on, which this annotation
never did. Remove it from the notifier invocation and leave the
constraint where it always really lived: in review and documentation
of the notifier implementations.

Fixes: ba170f76b69d ("mm, notifier: Catch sleeping/blocking for !blockable"=
)
Closes: https://lore.kernel.org/all/787aa26cf62dfd361eea8ed19f384fc51789250=
1.camel@infradead.org/
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Assisted-by: Claude:claude-mythos-5
---
This is a prerequisite for converting KVM's gfn_to_pfn_cache to use
SRCU for its readers, where the invalidate_range_start() notifier
waits for an SRCU grace period before the caller zaps the page
tables =E2=80=94 in the manner of a TLB shootdown. Discussion of that serie=
s
(and of the annotation problem) at
https://lore.kernel.org/all/787aa26cf62dfd361eea8ed19f384fc517892501.camel@=
infradead.org/

Maybe a "non_alloc_start() / non_alloc_end()" would be closer to what
we need, but even that doesn't actually protect against the case where
we *transitively* wait for allocations from the OOM path (qv).

 mm/mmu_notifier.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 245b74f39f91..cd5d15cd646a 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -520,11 +520,7 @@ static int mn_hlist_invalidate_range_start(
 		if (ops->invalidate_range_start) {
 			int _ret;
=20
-			if (!mmu_notifier_range_blockable(range))
-				non_block_start();
 			_ret =3D ops->invalidate_range_start(subscription, range);
-			if (!mmu_notifier_range_blockable(range))
-				non_block_end();
 			if (_ret) {
 				pr_info("%pS callback failed with %d in %sblockable context.\n",
 					ops->invalidate_range_start, _ret,
@@ -591,14 +587,9 @@ mn_hlist_invalidate_end(struct mmu_notifier_subscripti=
ons *subscriptions,
 	id =3D srcu_read_lock(&srcu);
 	hlist_for_each_entry_srcu(subscription, &subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
-		if (subscription->ops->invalidate_range_end) {
-			if (!mmu_notifier_range_blockable(range))
-				non_block_start();
+		if (subscription->ops->invalidate_range_end)
 			subscription->ops->invalidate_range_end(subscription,
 								range);
-			if (!mmu_notifier_range_blockable(range))
-				non_block_end();
-		}
 	}
 	srcu_read_unlock(&srcu, id);
 }
--=20
2.43.0


--=-0ndT/EUD6WjSKs4Ijo6g
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
NDA5NlNIQTM4NDIwMjRDQTEuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQChxpuuHVw93mze9jmueUFV
BJNzvOzZlazrt0AiW1H7TlYQutgKVXPNSEyz8s4k+WsRSjjlQMOiZerfwPEV6lo9336I0uNd+ffc
Rf8gbjiPTiVT+gX9GD1V5AguRgtsJn/H3A6M0dlzhI3J1jsOG9/+xPloHPzy7sPn5rNkntB/VTnv
Bix4IfUy3ScOu2vnLX0gnwP3EknfdEUvq9+kdkEEBDz7dGqQo3EuhXZoW9CHF2GM0sOpO/cuNQh2
JzA+to3smTES7sJXYuRrt5GomCRYvtIrRiYGMalFp+z6Jw/843lEIIpNNvpWVfx5Mbawkl+wWG8k
0IK3rF7FtbNa0it8/s288G/AEHvfsDIQYFmRLlo2LNMxxREkZO/1Qq8GHUsX/602Fi0u88I3uh5w
bOEIeG32NzBKTKBOjdjpiUrdCA676dyaIFt967CUtnUvFti8bqGA2pe/u7pjIANthqMBAlcnY5B6
ff2mbdD8BBLItgb4HyUOCVawzy1hc+UR2tglySwYroWeohfoG6afjesGigsl2JmnhaZ9Z0vanF74
vFEOOmuaq7VamuLEPFQtJM4olmipOW6CzrLcFz6J/6yAecEG3P1ZDoy08eSHvM40MAUgpwGa/w6o
9ALHQXda/c4TJvAylfHQ6wqArzAuV1pfWldwy7IOBMtKqzQBXQ4dSDGCBCAwggQcAgEBMHYwYjEL
MAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTowOAYDVQQDEzFEaWdpQ2VydCBB
c3N1cmVkIEcyIFNNSU1FIFJTQTQwOTYgU0hBMzg0IDIwMjQgQ0ExAhADNSi2uzJskfEdOMo4hV0g
MA0GCWCGSAFlAwQCAQUAoIIBezAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yNjA4MTEwODU4NDRaMC8GCSqGSIb3DQEJBDEiBCBS3WJnRu4QRtmw1iXEF7Ci34hncA5a
ZyOTg3L78ENJIjCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGln
aUNlcnQsIEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBT
SEEzODQgMjAyNCBDQTECEAM1KLa7MmyR8R04yjiFXSAwgYcGCyqGSIb3DQEJEAILMXigdjBiMQsw
CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFz
c3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQgMjAyNCBDQTECEAM1KLa7MmyR8R04yjiFXSAw
DQYJKoZIhvcNAQEBBQAEggIAflgRJ6p6D1LlVijEHEbJLVN3RAuDZ5hqSJEMhZfKD8h1pW8XL6pE
iLJxFCbEM9Wd2T9cIhFaQ05OWJJI4nvB9o8NSVTsgc3XltK7UNPaY6ZfAbKkpgB+/TxhLyaJs5HI
sbeRD/hX05AT/O69JmUIRXKchrF8eMrB8Inif5eHBZF5f4TAtRqxcXbNpDK6FPDRdCGq664FFH+L
9R9PyRHavgp310wUmr4VSOeDqdQ+E+5HArcHm+z1h5JKI9OvwkgUO5d2aUwFaYjJA2ysz6Ka34nP
WSBtOwI9kU70W6HegKfkrDxoZ2ZIPgCkwchX1eM3O/NXJ20/6sSLkLyxgZGInXIHOY04Tt7oPfqo
yg68+bHB6X7dr3aUR939ixJmop26KvGiNXQhZzeEqdlcUfBOE/8Op12Rkd1KD5jWcHHoPQRD4RAF
8/V6b4Gpbad2qXdHm3NzG46CTspYAMJlptPpE0JjazyoEH/JUufisfUUtwpIlaLNiYCtN1JdUUx6
qSaF9//a6sM/rvvnTdIw8S29Js8L2yFoJWummlT3JwJI3+Jo5QJ1zV6nR+DS2NfHSQFcjxVv5nIR
7qdtisE2f1Rq9cYScN1M5V+pgbiQVchvRplcOfCloVxBBM9/ndGlaqywl+vwloUsvgWiwMSy2Qbz
I89aQdBFas0az0seDL1M4hMAAAAAAAA=


--=-0ndT/EUD6WjSKs4Ijo6g--

