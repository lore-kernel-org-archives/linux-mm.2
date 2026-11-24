Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCB6606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E5h9YQnW
Received: by kanga.kvack.org (Postfix)
	id 7F4C46B0777; Tue, 24 Nov 2026 10:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5846B0779; Tue, 24 Nov 2026 10:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646166B077A; Tue, 24 Nov 2026 10:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 385B56B0777
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:37:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF6311C3EAA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:00 +0000 (UTC)
X-FDA: 85470415800.14.36669EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 41A641C0007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E5h9YQnW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534619;
	b=fnIYzTohzh5UdlqfB8crloAIMWRk7laCJCS5HLtNWmd18neFFyrEv5BiIiQa3S5iUn1LqL
	e+dzWgXCIiUnIIUCfJWNU7OPIzaUwr7o5BC43nNj+LyC9G4tJlHD0OrKXrbLqNx7O2C8lA
	orbWu8O7K7sBk2YWej1eKGzpNI9Jotw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEjKo21GUSpaZYoS3oGl37XQDP4bLf817sv8GkFZ5dQ=;
	b=dFJBYQYjgLaZj7mLQCy2pYYm92xuiFTKgs/i1xXM6RVN2d0J6NSaBFaGQatxMijFOPT1ua
	0E52xNnfE9EfiXzyqY+6KdIm3MxIa53kQv24wkAHyJB/gHsrs6Nqse5P3Ds7pJpajOg9W3
	OIyL2IYVZlvzgEJz01+ZN2GiHjmGj8Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E5h9YQnW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BFD542479;
	Tue, 24 Nov 2026 15:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1349D1F000E0;
	Tue, 24 Nov 2026 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534618;
	bh=xEjKo21GUSpaZYoS3oGl37XQDP4bLf817sv8GkFZ5dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5h9YQnWYZawNwmytHCWraUthL9wG1CDuDKo6DvRayPOKNWDuAgt1n7saiDcg4pxY
	 GS5XVTqQX2JKm8YQcapkS8J8kykslHb0Q7gk7FzCS2Lh/9AiP8TIUaqnOKlsO/ctzW
	 0TRdcQJ8TE4UXi4RUXxkmCS8HNt2tuZBb3deyxGtYjpIUDZ964c/aSVWoJgRe4fYM7
	 ROqEKsZDl7x31xsAc2w5VCk3lwbW7aI6ymN1A3CWv/+TtA+Ns4OQHwDPE3teJl+Y01
	 LERZIVfNYztdL7NAuT4cOcZVRA226NbFKWOLRTM8+vsxHGDEmt0uLMNHuiJ0iqzJAN
	 FNIRboT2uTmSw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 18/27] Docs/admin-guide/mm/damon/usage: update for REPORT_MADE probe filter
Date: Tue, 24 Nov 2026 07:36:24 -0800
Message-ID: <20261124153636.91854-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 41A641C0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7xoohxeztdcb8tzwfz465em9xb8765uy
X-HE-Tag: 1795534619-782448
X-HE-Meta: U2FsdGVkX1/ZP1GttkLScpWS9b+wNGDC94xGEheuCyUtzLOxOOLMD2DuOpjuvCqVSP2WlcGDs4lrvhRlaB19IV/vK3XXe5DLTj+6FXvRGDDJwOfO49YKApC4cVYQ/XcfYPJ3fKxFIdVtB4xm+WSvoyH7MfhCbHk/xLpe1CjTyxxwBRF/GVVl+mc42yO7J20c6RHOflI6ZsXXWuxQbpaoXLcjK8NvsfsZoZM6LG2hp0wPbcRAr+emcXE9BjPr+1YT9IyJNGQQswy/MdSTHk+R9oWBsUIubC4ML8ZxWtv0qQ9p+dCNpYcvz078/Yqj35XnyKP16GwgTAEuKvjKMxfi20dtojmnvoTmA9t2FB0hrtkQNYL4xXfhqyvX9pu4uAuKvaiZle3NM54hJcQeZblc9JC2AAvH4RHf93Seh0qKCtiD3iAjxCCiRHjoSdjec3lpQjYSWKoXC3f5ArQHvXkUhFRfOQipqgNZpcqtf29kHITmBkmnGvWtuyGxDKu0a01lVU5DIxLLBoyZ4wLEYBNfvSkTDZ+u+BdpIKtkdRSyDvJ0zAraMjdSjMFdE8vbOp3+uecTsc+dNt1JNhisokRMSJqu9/HyfG1e0ZnQ/C0c6B3T3shqMLK999X/W0xPcIXI71SnNb2GS2wd3rUYF5OyL/ev+iFYlv1N7rczfs9GwoTRgXoxZOwaQj1PhqY4qFyU9yIgtUpWU0x292ib26ADhRmXeNaSBUYMR7Vkcy1c3xJXcPeyNEz6FRxyT7hVnUb0WrR3TUgOnzdGh9DCCTFQVt2Pqm/TtJ4Xx7/jsCGVoXNg475D0FQHAFAgDlq5G7VK6YOnp3QONF9BA0hhn9peaA9qOt02ZtDcJBecyX1AKd7H6TKdqpX99eH3ERK+cF5qSe1l0yC81pVoi21PyOFFVLmOJPzFtlUm8GYRI62GGZYsPqOr6n320XB8vuNGNYXU4z3j2L8Q6KiCBwwIL6G
 7ejYYlcS
 ymw4Sq7foiv0ZTvI3LddSXOBjfLfFYLzc+qpm21v6ms4xSbFOoDy5aIH2HPwbvsJ0A6y64WGhohCt0IgtanWbHJ+GJHfWfdStaQ3iJ1nJqeDj4A5JMID2foSFKErnw/ZY22pbqZXaBsdw4KoYCfZOl3m854uBe6vuVWzNMoSwjypDtmxGh6XRhWjiWPoTeBKV0e9Nhzeat7fL34A51NebFBYXLxeblgDjTIieR7r2t/BdTI5oCbqvhSMXsWP5I8L1MidoL92BAuIvJPt64wlfqk966ji0RsjxT9rqGtpgpCzEytGdPHeqRVZeQGJHFJ+qQ9d1qJrS30bTR5QnYWwyA0gRBUMKroDpMTGf/wIuwfp3Z7FJSALQ+S7yqQpLdz37TaP2OtBJioNnUiFktBUinxhzjV9YWhoDs3F3bkBMddVLGBi2RMGWQRr6T4yHaj+1eFxEIhe7fn9bMfDgyNs4QfHTfSvkRemKmvGgRmS3kn3zQ3u//4v1J9GA/UZ8Vfz/mF+AsMB8N7esdAmQVMF3DTiuFRUk0qxcsCJTGdEUG2ICM0w5JzwPdy1QMtWWBUz6l+vVZXpuMA/LVqgsNAUxiWb+xgRdyG65MzHV+FCO5jHVc2f07JMwMrh9l/7HcjtIoMfSth703Wst/co=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added REPORT_MADE type probe
filter support.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 5e0633b5879de..dd752b81efe34 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -78,7 +78,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/prep_action
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max,filter_report_type
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -320,6 +320,10 @@ filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
 ``min`` and ``max`` files act as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
+When the filter ``type`` is ``report_made``, the :ref:`report
+<damon_design_attr_reporting>` type for the filtering should also be specified
+by writing the type name to ``filter_report_type`` file.
+
 .. _sysfs_targets:
 
 contexts/<N>/targets/
-- 
2.47.3

