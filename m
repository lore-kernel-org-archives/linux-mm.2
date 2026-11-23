Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70ED0606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=STkenfZj
Received: by kanga.kvack.org (Postfix)
	id 87D0E6B05B0; Mon, 23 Nov 2026 18:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82EC26B05B1; Mon, 23 Nov 2026 18:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C7A6B05B2; Mon, 23 Nov 2026 18:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 337BD6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:37:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCEEF40A75
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:37:22 +0000 (UTC)
X-FDA: 85467997524.29.8A4EBE6
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf06.hostedemail.com (Postfix) with ESMTP id D67A7180006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:37:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=STkenfZj;
	spf=pass (imf06.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477041;
	b=BxWTCFuhK1MzlQC3WuQ55QfVIrz6ttXqUbigh7Q03A+TXzKT1ndX+wHRJ6eBb55zHr9JH3
	rW8JuaqwXN8Fc4t4xlfHXob7L+ttlPIXdIw0+v6L4PaaE3Og558XyzuuUPSDMxmKGzkOgJ
	Czvspm0Wug+W5kYqzDh9k371EnyVo/s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZhwtoY0rC9tiCZjGnjs0trKwj1W0j+uoO6PhMytwUs=;
	b=Gwl5V+6xHb/L4jgPOxpaNXNhwpAi66zgtUbJ2SsAt0uykV57DimpwYWKKjSiWse8l+H7lm
	zgk+TVR5+sc5eQ8X1d4xNS76uLlzGiN8AUvp6KJBUJoebxbRgxjtJlKtfQrobszVd2edih
	VZoSyuyhe2YFVq0v4M3krjbXmWxoKpQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=STkenfZj;
	spf=pass (imf06.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jYMmb1Hz2zlfvqM;
	Mon, 23 Nov 2026 23:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1795477032; x=1798069033; bh=vZhwtoY0rC9tiCZjGnjs0trK
	wj1W0j+uoO6PhMytwUs=; b=STkenfZj4VkbVQLHeDA3XMnNB6jkg7p1pv3acqQL
	xWYVRpEfS0spAZLFnHD8/R7/Q5lF/lkNSDTU+UCrWMtlnqyGg27K3HbAQLmGTOwb
	jgn8KzoBzVaZnayMIizHneXNIFV8jyo6tZ7iMl0q6tWdXL7bpbSpeNBrOs77QKTw
	jhE0nCnBZFVnnWEFpEeIQnvV+t7/8RdsItTcEJFR8DXTLi93Ap30n9Wz5ko52yqB
	405kclQYg+Ccp1puRKAM7b/3h/34ybQWDe6wE76U2UWLwa+hsOt+v1/NePhzrgpA
	nHO/rn4nNX4In8GsF7qRR25ngg6s040aJzgMYByVIXiFyQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vk9VGeuZSzFz; Mon, 23 Nov 2026 23:37:12 +0000 (UTC)
Received: from [100.80.227.185] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jYMmS40TJzlfvqS;
	Mon, 23 Nov 2026 23:37:12 +0000 (UTC)
Message-ID: <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
Date: Mon, 23 Nov 2026 15:37:11 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
To: Finn Thain <fthain@linux-m68k.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Arnd Bergmann <arnd@arndb.de>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com>
 <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
 <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
 <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oycgs3e9xyjm5x8rbnm4s8i5fbqja8kg
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D67A7180006
X-HE-Tag: 1795477040-737425
X-HE-Meta: U2FsdGVkX19DEUH2Pr5X/93nqGEJ9vcTHRJ6GosqGenB2LXiuI8CCmkGhErlLenhj9Ld/xUD0X3gQHZzQji3wtTlc/K0jE568tInFkIJagG8fTOPiU2sG/inz3BcGwGBTUXmwPJc0pbTFpFkdfwH9g7aMn6AEdKtH+xr4xYuujgG4/mwYoTOq4ph24187WhbKW0PdYwTpfEP0JZa9UaswxxKE8mm+4cFD0qULhFkcOzqxGSZ2Nh4g5BE83S8Zv2IVmiw7QIC2bvmI6TcpAmAvU3cvhgQH7bVLw2A8mms9CtUUGtVcZPQy4oIjVhoefUdKJNgudlb85Mv8GBXJxIuatfU2BtbDtoTTUJnxDWEppmJ97kKZ3Vz9BBv8bhjCFOMwN/zcjbMXn54qRjCgLddr9l+dixkrzFRwnbMs/QxZL6iqg5HvJ6FhrFyhe/bqmUk17iZb6K1WXcWLk6BbpkVTTYFhg37AXFPwLHR++q83NJIajXYoKQj7+S9oDLhx4sSSw9Yo6f1VKvRmZ+HPv+btVndYBpgI4TQyUAca6pJdAK8UQPZPLEjOQPu1ncMvZzpYP+htXB/GMoNCbOkzzANR9mliDVMeaKC45uQ8UllJdOlEEGCL5C14Pdy0buH8LkWWLQuMYc3oqhZ+NoFZ0xAXEIObdMbK0lJvH8gyCLtf7a7meseHPxRNtC5ZsIJNd8aLTMZCjBe5Th9maKAErbgjABSHuOhK0sgUmuw8TpS/4AYEob+CEW+D4rQdL/Zd7ptWngMf17IjxOs4u+vJM7vn1aAG6lkIcNigJAuSvDpMxD9r/9x9ngdmgs5CE22iI3EyFnYuKvVzekOxUnmgg/sJGqWWntmujpaQIoeyumPeomfIBv5AAEPBE/e6GPd1LAVs4MQ3NEFJtfYiP5WC93wXQBnOEf6KcPAtuT/xXjqZyHUqW815kTszmzovLwtnRwt1YUNIgd45rFtECBWNo9
 kAqtSWkY
 nirxNDWf8xTJDYrjcSussLU6MxGIzOwlybQv65GXW3NnaZvUCxhUUF32uPNfohbUZs6zZBlkdH4ofxKvGx5b5m9POFklss4quOQiDyj3HES47CG20VjTPLaoI4r9SOy69q9DwyH2fbvlgECCpdQjQ/koI7T45N8Z12/q7OIQpwQh6TxBAoqvU61KIy7qKJxoBAJDLXoIVTEPZHpKqzRFudMovlhURQfo70JCPdqId7DP0AEqN2JJ2My3tdaBZdVF2NKf7jLknesft5X/HwFMiK6FEVCp1zhbku+SyYGvqr9MuDVX32sgk+9slGpb4ODw4UeSKq3y0VSltKOmc3DIEhZC2RO0h4GO6cuRb/Ts8rGxgpta5u3aicrz6UziIREPhyNubH0o2NURXhBNshsVooJcPlSwPwaYruyjK3kzO0OYZLJ6neyLdoCo8WPQT68zn/gPVUFG7l5hr3/jwELNIXLi8gHZp9uF3ZLQGtrbnc43fV3fcQYasE+uOWUFnJaq/p0A1QnuOBO3QobPvBreEDEqThHDm4c23acDMToHgc+4Yw2pyLTvieGZ0KXfZCroAyX/AbtxBwC+8NhivlbpW7XlOelO7mgbXK6lTUNf385xwCvuVkgT4t/uaHQw8u735c9dJeaRMo+6r81RwLowQyBmbod31qlH+XT4LPnUq7BT1ntROMpiOAlibxt/qUCc7GUKlOSOGCSKBBxYiQhX8vanxgNVtu0ZSUJ1P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 3:05 PM, Finn Thain wrote:
> Yes, two alternative solutions were submitted in March (either remove the
> assertion or rework it). The build bot reported the problem again in
> September so I resubmitted the "rework" alternative. Sashiko-bot didn't
> have much praise for that*, so now I'm leaning towards the "remove"
> alternative. I have been advised to keep re-submitting, and I will do so
> after a suitable back-off in retry rate i.e. 2027 or 2028.
> 
> *
> https://lore.kernel.org/r/93e35f60-e465-7f76-0043-f997fe2ec8c7@linux-m68k.org

What an LLM came up with after I asked it to fix
https://lore.kernel.org/lkml/202603030747.VX0v4otS-lkp@intel.com/ can be
found below. One of the comments of the LLM is "This is essentially Finn
Thain's "Rework BUILD_BUG_ON() assertion" patch with your two review 
comments from this morning applied". Sashiko reports "No issues found"
for the patch below. No Signed-off-by from me because I think Finn
should be credited for his work instead of I.

Bart.

     scsi: qla2xxx: Fix the qla_tgt_sess_op layout assertion

     qlt_queue_unknown_atio() allocates a struct qla_tgt_sess_op followed by
     add_cdb_len bytes and copies an ATIO plus its additional CDB bytes into
     the 'atio' member. Hence no other member may follow 'atio'. The
     BUILD_BUG_ON() that is supposed to verify this compares the end of
     'atio' with sizeof(struct qla_tgt_sess_op). That is wrong because it
     also triggers if the compiler adds tail padding. This is what 
happens on
     m68k since atomic_t is aligned on a four byte boundary: 'atio' ends at
     offset 102 and the structure size is 104 bytes. This breaks the build
     for CONFIG_COLDFIRE=y and CONFIG_SCSI_QLA_FC=y:

       error: call to '__compiletime_assert_431' declared with attribute
       error: BUILD_BUG_ON failed: offsetof(struct qla_tgt_sess_op, atio) +
       sizeof(u->atio) != sizeof(*u)

     Additionally, the BUILD_BUG_ON() does not detect all members that could
     be added after 'atio', e.g. a zero-length array.

     Fix this by adding a flexible array member after 'atio' that represents
     the additional CDB bytes. The compiler rejects any member that is added
     after a flexible array member. Assert that the flexible array member
     follows 'atio' immediately instead of making assumptions about the
     structure size. Use kzalloc_flex() to allocate the structure. This does
     not change the allocation size.

     This patch is based on a patch from Finn Thain and on a suggestion from
     Tony Battersby.

     Do not modify the memcpy() call in qlt_queue_unknown_atio(), which
     still writes past the end of the 'atio' member.

     Compile-tested only, for m68k (Coldfire) and x86_64.

     Reported-by: kernel test robot <lkp@intel.com>
     Closes: 
https://lore.kernel.org/oe-kbuild-all/202603030747.VX0v4otS-lkp@intel.com/
     Closes: 
https://lore.kernel.org/oe-kbuild-all/202609301230.CauIUXCF-lkp@intel.com/
     Link: 
https://lore.kernel.org/all/4808a5dc1a71528ffa3360868561009744277450.1791502886.git.fthain@linux-m68k.org/
     Fixes: 091719c21d5a ("scsi: qla2xxx: target: Fix invalid memory 
access with big CDBs")
     Fixes: e428b013d9df ("atomic: specify alignment for atomic_t and 
atomic64_t")

diff --git a/drivers/scsi/qla2xxx/qla_target.c 
b/drivers/scsi/qla2xxx/qla_target.c
index 5a7caff61b16..afa96551c13c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -212,9 +212,6 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
  	unsigned long flags;
  	unsigned int add_cdb_len = 0;

-	/* atio must be the last member of qla_tgt_sess_op for add_cdb_len */
-	BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) 
!= sizeof(*u));
-
  	if (tgt->tgt_stop) {
  		ql_dbg(ql_dbg_async, vha, 0x502c,
  		    "qla_target(%d): dropping unknown ATIO_TYPE7, because tgt is 
being stopped",
@@ -227,7 +224,7 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
  		add_cdb_len =
  			((unsigned int) atio->u.isp24.fcp_cmnd.add_cdb_len) * 4;

-	u = kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
+	u = kzalloc_flex(*u, extra_cdb, add_cdb_len, GFP_ATOMIC);
  	if (u == NULL)
  		goto out_term;

diff --git a/drivers/scsi/qla2xxx/qla_target.h 
b/drivers/scsi/qla2xxx/qla_target.h
index 71bc1affb1bc..c1559f034f85 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -845,9 +845,16 @@ struct qla_tgt_sess_op {
  	struct rsp_que *rsp;

  	struct atio_from_isp atio;
-	/* DO NOT ADD ANYTHING ELSE HERE - atio must be last member */
+	/*
+	 * The part of atio.u.isp24.fcp_cmnd.add_cdb[] that extends past the
+	 * end of atio. Must follow atio immediately.
+	 */
+	uint8_t extra_cdb[];
  };

+static_assert(offsetofend(struct qla_tgt_sess_op, atio) ==
+	      offsetof(struct qla_tgt_sess_op, extra_cdb));
+
  enum trace_flags {
  	TRC_NEW_CMD = BIT_0,
  	TRC_DO_WORK = BIT_1,


