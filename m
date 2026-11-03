Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E07606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=karaolidis.com header.i=@karaolidis.com header.a=rsa-sha256 header.s=protonmail3 header.b=A4zWXGhK
Received: by kanga.kvack.org (Postfix)
	id 5CBF66B05BB; Tue,  3 Nov 2026 04:51:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550786B05BC; Tue,  3 Nov 2026 04:51:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0AF6B05BD; Tue,  3 Nov 2026 04:51:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF2B86B05BB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:51:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6707C1A017D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:07 +0000 (UTC)
X-FDA: 85393339374.04.3D0FAAF
Received: from mail-106112.protonmail.ch (mail-106112.protonmail.ch [79.135.106.112])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8B9C4180005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=A4zWXGhK;
	spf=pass (imf06.hostedemail.com: domain of nick@karaolidis.com designates 79.135.106.112 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793699465;
	b=SbTDApwhXYfZceEPusr6mUc9iOgg85+OVoLsnJ3hzFP9o0MzOWUXMLwB1et4/pmaJmBSaU
	4j9HBX3ORBjD8/0CUUdOfX0TlFf+kPLm1RicvA3kXLY+8UBTYovyr4fLglllNPSc5A7K6D
	+RjFpDjNq9oY9IGT9YwtII/E7pdY/08=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=A4zWXGhK;
	spf=pass (imf06.hostedemail.com: domain of nick@karaolidis.com designates 79.135.106.112 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793699465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8mDAdHjens4fLiFQccbP/0Y8oUck8pzo9WB/WyQJwc=;
	b=DG35l6JzMcnWvGnx2Ef99uvrEPB6d7HoYwjTOs/pjubZT0QrM1FuU25LeTq44sVHnmNLtx
	4L/XrFV8ZB5zli/YeVO3mIHeV2M0eazadFytp1f8JKOquDKKXg6B/rKQO5t6YazkkVCzmj
	XRE3bvybcYmD9EpGMg83vvbTOoK71nI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karaolidis.com;
	s=protonmail3; t=1793699463; x=1793958663;
	bh=M8mDAdHjens4fLiFQccbP/0Y8oUck8pzo9WB/WyQJwc=;
	h=From:Date:Subject:Message-Id:References:In-Reply-To:To:Cc:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=A4zWXGhK7fPCcUFId0bIyVWNAGFLf+Tih0RWhej2GZkoqyDUuQfIiwemw0pszZyZZ
	 Zcxc8PKz56Bd8UtbPB8jkRIV+zkh5rwH7+xkqsUbNBAt+Um5qKVwTbm/KMdshxckN1
	 ZPAVdHU1DpVGH160Cgru0oQ10RNv3Fbjx0HDb63eh8P5gp8hWBXNuldGznBzPD3t7L
	 XDTv//gMM69uPD6Xa5Zh8Yt4fd1ijYHGv9O+4qzHiwee0raLEEOhsZq3I2H/7OD8lJ
	 k7H5qcdMfxoaXT28AyLpWhpmXBwzSXom6rN2DwW7PZPAM6pye1HXqgCzXmQVyVRf7Q
	 YmVfPaYiv0qgA==
X-Pm-Submission-Id: 4jJkNP0KKSz2Scj6
From: Nikolaos Karaolidis <nick@karaolidis.com>
Date: Tue, 03 Nov 2026 09:50:10 +0000
Subject: [PATCH RFC 4/6] virtio-mem: move
 virtio_mem_sbm_try_remove_unplugged_mb()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-virtio-mem-memmap-v1-4-308ae1da6240@karaolidis.com>
References: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
In-Reply-To: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
 Hui Zhu <teawater@gmail.com>, 
 Georgi Djakov <georgi.djakov@oss.qualcomm.com>, 
 virtualization@lists.linux.dev, linux-mm@kvack.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Nikolaos Karaolidis <nick@karaolidis.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2798; i=nick@karaolidis.com;
 h=from:subject:message-id; bh=GU2oa106EeH8dI11q71ORgUyNnPj2av4Aihez49DNQA=;
 b=owJ4nAFtApL9kA0DAAoB2mjImL9M9YgByyZiAGrprnc/6ByFXuJChDmSsarYLCIu+Kp2XDzMr
 lxN1joAcbphnIkCMwQAAQoAHRYhBLMZG7EWqsMYjymWX9poyJi/TPWIBQJq6a53AAoJENpoyJi/
 TPWIE70QAJpnT8Qz/qvNyHuWszstgMQamGr6va87wXLS5+gKnCmAPou+fN30tKYLqRR2nIBnCjj
 UvgMXUQ26+Fw7jcr4PimEuozX7cwly8ZTdQ60ngPI8XMV0xbN26ayd5jaRAd1pBLmtrgbS6BM/7
 OzLC2uu5Fw9OKG3dsj7TZrbMSOQlDP3qjKf7V7G7AbkzzJgKYeA0Q+B83ucwqqw2xKDGNNezQ67
 PS0jcdzFs0MQji/X95qL8FCw29Nhh3Qz9iRtc2TN9MZEWhoJPIyJcV8cCX0HIfU1ayqAtfRMiMz
 d/hCH4Q7u7dVciFK+xygmO7gIyleSLzTYBFk7J1EUsVdfHpQ0AEwgcjOgNPYYP3gqfV7CNn+YbK
 dxX7JkcX3zmXKAsgi9zPP223qfmr0uYYolNGWwwHARzT5G62hzvWy2sgJMpsGvDkr8NQhuc0W5Q
 ZqlqqCJd87kgps7a+LiQbZhSEnF3IQXqrAAysaSM+sZLTRqsbVl3+QaOfc9VXiBxJmocUiwBX7y
 idjtWa//M8BQPQPaLOXtAW14WkewCxDVmYiWKsgAbiahwW8ZKJhVEHhZGL1xdYVryS8F/kqDCrP
 btORLY9AX8HlX9mEmngfA2Xsmq27lX9n/aQ5RQTpeALH4NRikRPsZgVPYnRHm1wMvNBiQsAtQJ9
 r96NGUpvLFPWNVTg86m4x2g==
X-Developer-Key: i=nick@karaolidis.com; a=openpgp;
 fpr=B3191BB116AAC3188F29965FDA68C898BF4CF588
X-Stat-Signature: d133ufiircijxig4fiwsaq5eywxg34cm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B9C4180005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793699465-232034
X-HE-Meta: U2FsdGVkX18qVE9kr4xlJ7HI8g4xlDeSA5+CJQJCGKjra4ttbnmaeWC5Vljg00Zv35Y7Wrr9CwbwuzPMEcQiGK2TaHhJIiAukwIBss3OCmpXKyzb7r7pyx6IQD53kIVrtE0pglgXjW97j+ulnQTpIdutbrz5WtjdyqKFBEu1j7a6uv6I5WhZH+ypxzvNgp+qEnpzstB6Quvca0tjP8idYVWrQC0t3q9QUxutqDeaE/yD/0c/7iuaqT7rIRIGuPYkEmvKWV5LK85W+bUmxDVcnDUYC5TE9SmqycRV1AB9vUnRx16A3ApqRIEFerWLGu5YKR3/a/Zg+HD84MsUYSj1T6EFAOWKhlxPi4V7lEQ7yMJuE4+bicSMNJnaFBKEGw3XHWjwg0zjhIbNJ4/OHmF8j7smVJtlVmfwmmTs4Rcitya2m+13uZhQKlFGQuk5x98pmJwB1MOVfrvhgtF6OH6ffIp9uYmhxFL34rFu4F3CM5ufsJXow/6UWDPN4rN3VqIOAvMU8CYT7nrajzZIsGXME4l5B42/ZzjxVtdtcptc1LVqMsQR/dSBehMTZi2xhVfwgFKTrGUudPrya3KLLsHIaOXAJIytTCbcGH26d3rDUCWhyk9GzHj0dxwswA0uAupHBJNjDld4zfi6LpP+geasximnoOzw4xc017hiSGRyu2F6OWtPy47FjEEQW32WbHsljUj9p/h0R5H//Y3gcyrBCvdoSjPAIPgYylCaMQEJ+XUK4PoyWhM588X/dU43v0ekS1mZVB50g3kQFdEL+5DhbCTzJc5nkPexHbfapRiYP0sbM8L5vD1vBpvzw7HuksYIIwFeXx3mPBJljs3kPdjvMAzVQoVrXtUl1tYSqQVaQAr83TV3KIUA8uvRPLCwlbortL7N5Y7Da/8YhRPCrJ1UHDAnhN0uwOWvrO3vjQXJBfwXurxYoIQOcDVCcoCOtuYXKVODGw6u4gK9M38rxN3
 oblEwMjL
 L31dE1Mnxg3RS1ic3JyAN9FXxExjglITS0OAVNetkzqm9pRMjsWN9wOI7RolbtlYa+vV7u11aMwPvF6oxh/x2g0/D/7DvRqk+Mt2+h5Cu9M/Su9tBaFXhDaESHuvVyaS0Xx6JCTwjq1avxxfJyI8QGGoPWThJ61o7TV1PdfN63AkUKaISMmV2sO2cU8ta0rHe8JY/c6e7ALNRH84o6T1TZjJfl1wMnc0sw5/gbmbfb+YozapdBPms+Rm7+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move it below virtio_mem_sbm_unplug_mb(), because the next patch makes
it call virtio_mem_sbm_unplug_sb().

No functional change.

Assisted-by: LLM
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
---
 drivers/virtio/virtio_mem.c | 56 ++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 034d07207e44..688c178c760f 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -791,34 +791,6 @@ static int virtio_mem_sbm_offline_and_remove_mb(struct virtio_mem *vm,
 	return virtio_mem_offline_and_remove_memory(vm, addr, size);
 }
 
-/*
- * Try (offlining and) removing memory from Linux in case all subblocks are
- * unplugged. Can be called on online and offline memory blocks.
- *
- * May modify the state of memory blocks in virtio-mem.
- */
-static int virtio_mem_sbm_try_remove_unplugged_mb(struct virtio_mem *vm,
-						  unsigned long mb_id)
-{
-	int rc;
-
-	/*
-	 * Once all subblocks of a memory block were unplugged, offline and
-	 * remove it.
-	 */
-	if (!virtio_mem_sbm_test_sb_unplugged(vm, mb_id, 0, vm->sbm.sbs_per_mb))
-		return 0;
-
-	/* offline_and_remove_memory() works for online and offline memory. */
-	mutex_unlock(&vm->hotplug_mutex);
-	rc = virtio_mem_sbm_offline_and_remove_mb(vm, mb_id);
-	mutex_lock(&vm->hotplug_mutex);
-	if (!rc)
-		virtio_mem_sbm_set_mb_state(vm, mb_id,
-					    VIRTIO_MEM_SBM_MB_UNUSED);
-	return rc;
-}
-
 /*
  * See virtio_mem_offline_and_remove_memory(): Try to offline and remove a
  * all Linux memory blocks covered by the big block.
@@ -1648,6 +1620,34 @@ static int virtio_mem_sbm_unplug_mb(struct virtio_mem *vm, unsigned long mb_id)
 	return virtio_mem_sbm_unplug_any_sb_raw(vm, mb_id, &nb_sb);
 }
 
+/*
+ * Try (offlining and) removing memory from Linux in case all subblocks are
+ * unplugged. Can be called on online and offline memory blocks.
+ *
+ * May modify the state of memory blocks in virtio-mem.
+ */
+static int virtio_mem_sbm_try_remove_unplugged_mb(struct virtio_mem *vm,
+						  unsigned long mb_id)
+{
+	int rc;
+
+	/*
+	 * Once all subblocks of a memory block were unplugged, offline and
+	 * remove it.
+	 */
+	if (!virtio_mem_sbm_test_sb_unplugged(vm, mb_id, 0, vm->sbm.sbs_per_mb))
+		return 0;
+
+	/* offline_and_remove_memory() works for online and offline memory. */
+	mutex_unlock(&vm->hotplug_mutex);
+	rc = virtio_mem_sbm_offline_and_remove_mb(vm, mb_id);
+	mutex_lock(&vm->hotplug_mutex);
+	if (!rc)
+		virtio_mem_sbm_set_mb_state(vm, mb_id,
+					    VIRTIO_MEM_SBM_MB_UNUSED);
+	return rc;
+}
+
 /*
  * Prepare tracking data for the next memory block.
  */

-- 
2.55.0


