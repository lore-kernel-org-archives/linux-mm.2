Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC6B606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y/AqMsOR
Received: by kanga.kvack.org (Postfix)
	id A8CC06B0787; Tue, 24 Nov 2026 10:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64676B0789; Tue, 24 Nov 2026 10:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A546B078A; Tue, 24 Nov 2026 10:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 729E26B0787
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:37:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E6C7C0C1B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:08 +0000 (UTC)
X-FDA: 85470416136.13.09EE066
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 64F7A40009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y/AqMsOR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534626;
	b=45rVBxwWbyHosZLGf+OD2zwUI9c4tYRKjowy16f4gYglCIXlbX6SL+flKN7Fw7tjAeG21+
	HdHEiLB/nuhBLlhcIQFbvTiLKCvcNPEjf7BAx1aeWgevJV4ONqQ46bp/cRbV9t2XLXrnq/
	DfHrWZjEf874nfN7NbR2hay9G93jYCQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqhmwcTw4aKoGyh7zdAQ6ulpj9BNviPX5fZGZSAf2zE=;
	b=HUGkUQUzqCWMjntG7mTXg2Hl/8Se+D0jz/YepLaWmePcLVRZ5Qvv9YgrAgr2RAl/KfTJyz
	7C50O8lpTm3j0A9FmmLFDNnqdIvSnZ5UCpgCQnKUGz2PFkZZAEo+lxi7pwr1Aycy497l3q
	vq0Sr+Kfx1k06Qg0NrXQdpkhbufcdd0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y/AqMsOR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0800D6243F;
	Tue, 24 Nov 2026 15:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060A21F000EC;
	Tue, 24 Nov 2026 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534625;
	bh=IqhmwcTw4aKoGyh7zdAQ6ulpj9BNviPX5fZGZSAf2zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/AqMsOR0wwJEglYyETt60ihIKF55pZiazQRwe1Q6GYQ5v6VTdoQmcqnGtjDmYLp3
	 4hrcCHzxgDQpIIvwi2zhDzrSqRELYikJDj0DP63JGlx07pIsEDCZ/LMxdmtRiL5xPm
	 QGRtQlbi4VFZNbn4VNC+0KyBy3AKkXD+Fh8Vm/BlKJV/2421Kaf+uJseaYehSxWukY
	 u0qmJxL1/gDwjKVpK8LkwgK8HoSApwlA8UC7ibvCEmbzM8bLPou9jaiCBPuM7u3+Vo
	 AQHM1ydFPhgQlbelKopjw+na9CDZTGb1voPkSReGZz0hD2TSAcDxB9fsMvqzY8vqpI
	 2+FNzCx+lB0gQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH v2 26/27] Docs/admin-guide/mm/damon/usage: update for user_report report support
Date: Tue, 24 Nov 2026 07:36:32 -0800
Message-ID: <20261124153636.91854-27-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64F7A40009
X-Stat-Signature: dwh16ekzsttigke1eueqhyh3fqb8n9uo
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795534626-893178
X-HE-Meta: U2FsdGVkX1+eVJLtePR+QbparLkriMfkdGa3TJGSyO4BuqN5ukaEuiX95SC3/GsCv9QupaPnfiOsAJrXvKiqD8LPaxlhVI1fu5nSXqfQhGWrGjk2E4bOG8/f4Y4e5T3vXFxjpg2RCXh4BLYmi4E4D0DUu95UHTithkTPnPd2UpzihjotBZA+1MMDH2bwGIj0TPP00Ct0ZGXKTcO8Q2AsG7YQjwEzbfmoOvl1gCI8yVs8unfj/q1NAFlDJGLJNMDd5vXcHYt7wHhrOL9Cj+YpGK3N9wA8UZBVOVwVQckCNVcw2pDp0fh7jA39bckpsb/nCRgpF2kk/im0dj35LeJz0mAUzHxAZ3K+Gm0w1WHTK4QZK5Lh4uCzXYbEhuVQCC6AnsiP3NMMHlrp2mlZaCgnmohp4vWPzsvK5PVmfT1RliHgipC8sMrtkQmGqPQtwedqaqiupJfu6BzVbRy2m4icjIbnKFDDcNoHGFFcYL3bdP3xvVu7G4b0XPg9pBO9PEbToCVKjdo9MwFYK0rN1mXcZntzo5tq+kRFckZRJDpLu/RiALk7/E3TLTvnY46nz23EZdIiVne9K5gUDkBSrFnYfDrF5mQe91i0CXQat/XPXCRNjV5oRW3mkJK6AM65niZ/eeYnZbPjH3iretCCxUb2QqLVOpXWypjuCZuEHxemm7O4uzbl3tHDyVd6A1PaCD/DR0sEodBzQyLTwztam8Ad3UuPwqpkBa7cQcDbex6pDc0BwLUe+8kQKUkWTcY34v9yZN6FzIoNFcO7vVH+9p+oc+Sj1vz/asYVFKxRjYDqj5IMwKzh6rprDz4ZCnvzv5a2gox2WnKKlc4ZFGTiVMGcLTSX+P5BQqSZ7xE0cijPepOGqEYmbHTOQrsQ8CsyDYshbob9EiHn/GW64WHOKFxaejG2fkzb2Rbd+Q6+Fm+uhYmecb1xylsrRZpzGuh996XhDsWdygTORqNBUlfTOS9
 eKRRbNFW
 qR4RUeLtWYbQSeT+U1AIVvAxLWMQdgFlMQ4RriLopQHl55FMkieT/uV2ogVuGb/nGNtVaOm2d+IPkYbjKhJQ52gQPbhnSG4S5lEtySGL/+AuTcJYZjGB9briVcMlqt9jnbDJnnSxTZctIa3IcRETN7FohJPHJZSrh6bDPMeQDSBfGMN47vuWMInw5qnbMF0w9ZJ5NTpX/+w/UOBhjEAjvHC59IUqkX6UcrgOebimBVkqLK+MKITiG3gPG/V23SW/WWVtihALgDvn8Yw7bajIVT4TAiKwTCGM98kwplaX3MSExfnU4vXEoOeienpPOeOCoPMKEunJ6LzQBto9R3372W5MR4RamFi5h/NL5RZKyCgjY9fpoEnWtpPwu8Oa8P50RdZ8zRUQv65fJNG+mP+IpSDrv9fvsdZQRzjNplEJxp2oQk6YuBFIrDzn3wPPD6MA0vBLMfOMmznQgzp5iwpvYtd8by2CUT27NQiMuvrkGZWZO7bs6xbqV7yXt1vprwCDvGsOjM0G9h30qt1wkETeL0RFgTJQ5/qlg8jKaDcH2Cn93WzpkspVeA7HE9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added user_report type data
attribute report support.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index dd752b81efe34..9312db5973aeb 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -120,7 +120,7 @@ comma (",").
     │ │ ...
     │ reports/
     │ │ producers/nr_producers
-    │ │ │ 0/report_type,producer_state
+    │ │ │ 0/report_type,producer_state,addr_start,addr_end
     │ │ │ ...
 
 .. _sysfs_root:
@@ -770,6 +770,15 @@ Users can write below keywords for the producer to the file.
 
 - ``on``: Enable the producer.
 - ``off``: Disable the producer.
+- ``submit``: Generate and submit a new ``user_report`` type report, if
+  ``report_type`` is ``user_report``, and the producer is enabled.
+
+``addr_start`` and ``addr_end`` files are used only for ``user_report`` report
+type.  Those set the address range of memory to manually report .  Users can
+set the start and end address of the address range by writing the addresses to
+the files.  Note that it is open-end range (``[addr_start,addr_end)``) and
+therefore the end address is exclusive.  Reading the files shows the last
+successfully written input.
 
 .. _tracepoint:
 
-- 
2.47.3

