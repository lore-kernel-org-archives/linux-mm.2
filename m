Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B946BC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7386B008A; Tue,  1 Sep 2026 14:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57796B0096; Tue,  1 Sep 2026 14:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F8F6B0099; Tue,  1 Sep 2026 14:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90E186B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B21180518
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:28 +0000 (UTC)
X-FDA: 85165975776.20.8B0FED2
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf01.hostedemail.com (Postfix) with ESMTP id 405C840006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=W5jk8k1Q;
	spf=pass (imf01.hostedemail.com: domain of 3XBSXaggKCD0clZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3XBSXaggKCD0clZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788286046;
	b=3MmQlbyap13Ddsc9RlduNGIbQF1WfZ6Tcg8TZyPJe4tQeXiT2N80nlqiB1HM5PxHJ16sTt
	AcVyql9y1ET6KBlQXrZatT/m3dCgSRG8sBQDeKLAVRMiLdVTZ7Zd2faVR0V1FLqEmSaTB3
	8lJEemnv3uSdkUsUoIqqcPgBuMDa2kw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=W5jk8k1Q;
	spf=pass (imf01.hostedemail.com: domain of 3XBSXaggKCD0clZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3XBSXaggKCD0clZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788286046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3UHjUhSHEFs3BDPKTwtfBJ57unvd2KtLqU4zpNQnvE=;
	b=jzXfcNJP39FO6K8IEJoVCcRiyZDf/ERzUwYdywcmfH1AMIAAZJZV6g6UoiZ8acwg4UKct7
	AjHuLYqk4nwWUnNwIWPyNSWMpb+kNQlvZDygYUY7i16RSIp9x7YAsjLh2Pb8p/nq3W2Pw6
	AIJEKKIfFV4tyIRhbVa9ZkxNhSwtBsY=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc1c62f0d60so252830a12.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788286045; x=1788890845; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j3UHjUhSHEFs3BDPKTwtfBJ57unvd2KtLqU4zpNQnvE=;
        b=W5jk8k1Q6A+X9UlEHgaenWsS2t2B1lkCus0Gp5/Vw6F2BIjRY0eikft46SeQfuBF35
         jH5cETuTW7bxAMJyjKlO/XbQAEOvEyccrlG2dp5RYPXvRsQcLqmg+nzN7JDcAi8wC/qv
         P0NbvRwewX2iwF7ixPbClEu1DqYTnqJ30jXElWVBlrPO4O0qWS0+pmLE9r69Gw1ZP0jf
         R7bksEs7gJH+MSWVEJArQ6onhcNJzLT4y/ZHZvV5RzUC+1tnvkLUqHVME2g/3P2IcP2o
         VtS33LMlRsEFbrPjCXQNjSmNv2pTbbXIh2aM6YvNMNRbw1D2tI7f/2lKPOjx8iEABj5H
         v7wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286045; x=1788890845;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j3UHjUhSHEFs3BDPKTwtfBJ57unvd2KtLqU4zpNQnvE=;
        b=BPGAb1BqMJsKT9oAxfkpXpLdFffT++DN61OcUS2x6PTBD2tliKuetidP2Oq/eAmOrF
         5w5US7lknenQsQVCG4MBj7h4wa74UWkLENfGcu3vntwmPkrzLzmT6dDUSLi7dWwxO6hH
         5EpebZ0G7SH9J+8PBG03PO6KLpawhNJX4pz1fXx4sM4Ml0oH6fjcEpls6hYulzOgf8aP
         WQZq/h05veQQ5ug7zkNH7NCyj79m4roGHJicqlThQF2pUN2q+Jt9ilAQYtB9Hucp8Hae
         nhFhwu2hDRZlQXRRBMs28smUiy4L3GA53poXWMhF26JONB8fPyWlI2mmjQe3vjQ3wTGt
         olMw==
X-Forwarded-Encrypted: i=1; AHgh+Rpb9MiPbUeq/DhCynH3WuKuH4dVi9kUSEncfZMWFveegtSJuIlj1BqHP/9V/vm1096kHDXkCSN2Tw==@kvack.org
X-Gm-Message-State: AFuF++mx616LI9qgMMJSOc828FtIGMAoSPPfQxhP1sCsY25KWASO/UIL
	4CxBbEXUTyIGRDqdTwC+mpa7oet1Um1Ah2mobI03wM3AAVWBYfEgtAj64aeWSyDsBQheoUTEKwm
	x4zOqd+b+a+4taA==
X-Received: from pgp10-n2.prod.google.com ([2002:a05:6a02:62ca:20b0:cc2:2955:6540])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:7a97:b0:3d0:cc29:ff64 with SMTP id adf61e73a8af0-3d7af8303a1mr17251598637.15.1788286044618;
 Tue, 01 Sep 2026 11:07:24 -0700 (PDT)
Date: Tue,  1 Sep 2026 18:07:09 +0000
In-Reply-To: <20260901180713.4185641-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260901180713.4185641-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260901180713.4185641-2-dmatlack@google.com>
Subject: [RFC PATCH 1/5] liveupdate: Extract luo_file token lookup logic into
 helper function
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: gtnwzfmk6p1tf3rjm1y9mfxxk3su914i
X-Rspamd-Queue-Id: 405C840006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788286046-633652
X-HE-Meta: U2FsdGVkX1/ZJfN4HSJJCajFc6MlsoTs//1aUqCIsgR05BpROoDMIAAc0kzyoRER5WJ0hJtKZ5GNCUGoXCD+yVjkEWppjDUKfg4lbekGpKfrHVvidr//VxsXncyjBU1AzFaTWi4HMro4HoSPKN9Gtd/Yo714XBlMMD1I005Zj1UAWKRYLaHrEzQk4IFsj/bjquXUhNHfNMExEdj31hog4VfFfZzlrd+7nTUl6n8p+gwR+n9fYoMaKuOZseVSmZvU5Jgk9DZ0yRy3mFilZLVoMSSwM+j/Vptboe8IkVbXPF+epuZ6DyM2iZdqS6KtMiHfwjqMYa38zOLFsjEvruK6TJl9Evuw2LiU7HC6cXfTCuia29tN0vFXlclSc3FBGE9dBqBg6VKUNjm3IQ5k46DIinoduQNOi1T3YNZTJueW79Hf+HTxn8eFUKB7fQfvFGkE9+65UxekYx7HyHhHSoIBz2TIlpTTKHrhzb+BdytThrZo8W7anTmBXyshzeMCBc6j6yLoZfW+q1Mk70iLGb37HSDanaBRd4LZ4LwMXMW/6Ph0je/TxowihaSPl6D773tGgJO8Z52x//GCdRBb7XQTvaNUdeyWecLbZmitkSxuCEDlDJPpEg9uQdSEOs+0GR+Eg9Cwl/MEyd7uUTwyVukFiwuI6vk7VUMPUHDa+16+v7kl/q/ivoJLBsQMw4xwtO3bI4B4qtm1k0REyuyIxNcHzmfeyymA02SeW6jX+69GujM88yMA21sAi/ljAWpG/LFOX/1l5njNI075wykmLxxwJZ9Bvhv8BRA1X6gFXdnNesPb4uAUqDednme5MXDc8hIUYDlqmDB6Nf7o10V2/nyQsZ3cXRWPvNyp5CGUnwSWxJJkuPy4qxjIZRI7K7Rtz3hZAHPe5RVaMrEevJs5b9whIaKEhzVLbl6d4AvDZzPjsRZ+n0T3NrB33itmn6M7alS97YYb5h6UlVuSslz2JUs
 9z04NNWg
 561j0OEuoATzxuw3x1qX/zYHB6VWqa14gw5XTxMPFKbqtj0mAvv9KP7BZTSsnHrighJ6O5tqRpxJFdz+MHkak3tkNLm5W50Ntig4wqHTqukdKbUMFuOhzMEv2or+kil94plZOto9A8+/lubDVbVmnh1mUUo4j3GzP7LiHktnLf9A9zKgJeQ3su6fx8sEUYMZNUQr7gZO+kVDHNCLu+1cqXQciL4vAQFLOL0GBeqFzg7XsqntFw+0JkDY5WzVGjNnRzWhjw704gNBj7PLM8wSmtstxI0wGxypvkNSDwOkG1+xgIVjkgHe2JYOQ4Lv59M0gCs2a8iBrzXEoe3YqP1C78+BVmCTHIEPCjrAoWwv8nUJbtHhT1Ohuq40Dh1Kls+/Iu36jvQGpYEJ20G0nzNlho4JGa+eF1IbBG9i+Ws1YP2Wks9EQ/whBWQCBMDz0mNTpewqV7HaX/6Y2oJFYaS4R1DW2Qd0j80m82dls4vTDnLvJrWD7EcL3IN5GOehCtd9RKdnAC3+Icg+SB9FZ+j8CDE1y2DxLTJ48i0jBkz5xprICmiOZJ8b66obSoMI9HwwPOLxCfawrP0+yzi2QhRPYDhExtr1B8uw7zeQMlDncZDORUk7xL24/JmFyVfTJ8tmToc68XgVoN5218Tg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the token-based list iteration inside luo_retrieve_file() into a
standalone private helper luo_find_file_by_token().

This eliminates code duplication by paving the way for additional file
retrieval modalities (like retrieving into an existing file descriptor)
which also need to safely lookup file tracking structures from the token
list before bridging payloads.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 kernel/liveupdate/luo_file.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index c39f96961a85..5e160836a165 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -549,26 +549,32 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
  *         -ENOENT if no file with the matching token is found.
  *         Any error code returned by the handler's .retrieve() op.
  */
-int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
-		      struct file **filep)
+
+static struct luo_file *luo_find_file_by_token(struct luo_file_set *file_set, u64 token)
 {
-	struct liveupdate_file_op_args args = {0};
 	struct luo_file *luo_file;
-	bool found = false;
-	int err;
 
 	if (list_empty(&file_set->files_list))
-		return -ENOENT;
+		return ERR_PTR(-ENOENT);
 
 	list_for_each_entry(luo_file, &file_set->files_list, list) {
-		if (luo_file->token == token) {
-			found = true;
-			break;
-		}
+		if (luo_file->token == token)
+			return luo_file;
 	}
 
-	if (!found)
-		return -ENOENT;
+	return ERR_PTR(-ENOENT);
+}
+
+int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
+		      struct file **filep)
+{
+	struct liveupdate_file_op_args args = {0};
+	struct luo_file *luo_file;
+	int err;
+
+	luo_file = luo_find_file_by_token(file_set, token);
+	if (IS_ERR(luo_file))
+		return PTR_ERR(luo_file);
 
 	guard(mutex)(&luo_file->mutex);
 	if (luo_file->retrieve_status < 0) {
-- 
2.55.0.966.g6673acef38-goog


