Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC6AEC1E92
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 10:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0464D6B0098; Thu,  5 Feb 2026 05:51:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 024906B0099; Thu,  5 Feb 2026 05:51:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5FD66B009B; Thu,  5 Feb 2026 05:51:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CAFAB6B0098
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:51:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9EF471B273F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:50 +0000 (UTC)
X-FDA: 84410087580.15.BD32DC5
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id C6B28160006
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HMQqgdyx;
	spf=pass (imf08.hostedemail.com: domain of 3Q3aEaQkKCJQy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Q3aEaQkKCJQy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770288708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wazCAdh5UgcB5estAlNP9lpZPIwk5UhZor5+EOBIZsE=;
	b=bmZjGwPbfsxm557aZQE3cWKHKSx0UGMMgleMSmNcaJinEL+DlaLwfA/VgHYs7Fcd8/GMVj
	KnHU7JaoT3DDYvF8GcqT+8IZGZu3EkQXngBpezNbPjvOut9hTL6ShOOhL3k+xwBtBVj96e
	18Ww3QLUlN4zBFv7fK9EB+8hWQb9dBk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HMQqgdyx;
	spf=pass (imf08.hostedemail.com: domain of 3Q3aEaQkKCJQy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Q3aEaQkKCJQy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770288708; a=rsa-sha256;
	cv=none;
	b=Ffro00EU7+su1gicJJUcUpj2oaXWGBri2v2Q1RV+fPHBgrF4s26+16ygf3V5lMvdaNaccG
	9pE1FMar3+SOByphGDkpV52sy1PNBHkm+hQqoTHuSx2KHreZxiv1nN2n9zbnhBMGOIZobt
	RiLnCwj3GWncLT718ppDyLlOXw0YuTE=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-482eec44485so5585555e9.3
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 02:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770288707; x=1770893507; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wazCAdh5UgcB5estAlNP9lpZPIwk5UhZor5+EOBIZsE=;
        b=HMQqgdyx0gOQfnUeKkFkENv0wSaPmAjrgIRTwX8OrmLTKrVSmLHaDViPPUm96c5PtU
         qevO4/ceUcoXl7HVO5Pb+A6VaedBOjt15IkUeAYt3JlPz0ISKRlt8V9yrVCOCSz6QU/x
         XIfSs4qKPEeOlfQseeywrVOFVwDe2OVfo727O2viioAczZxlsARxfg4j5QlL10mXqnhI
         6iySxbkaMtZbr7GjncTpzti2ypAVKNPgbWbpGV6NY/XW3FWxUjIxyAGIMHZxq9SgifgR
         2hZY3cfAdDwENj95QmIHMMbu7LWvnjmA5oT1p1YQbQblBdHe774g62XAIVA5y4gUsrq5
         g3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770288707; x=1770893507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wazCAdh5UgcB5estAlNP9lpZPIwk5UhZor5+EOBIZsE=;
        b=Xmtq/0B74PfojBmRDKZif5R+NhWMLDR4jP8NfvTR6K6gskknFSG23DfMz4hSE+bkG4
         uhqkJgo04FsXAwjJSO6lQKGGDxIzkKNT7bBGDmRctFRErTCdIFd/rEaNuMBK7Yu+CTqR
         THAqLr9J/ILCRnMZO7ol1JPXFVwyLCe2G3NKnK0aGtvenbWFGJ/ZfngL6+ItEm0C9eCT
         xU6MVtV2Rxjhjia9V6W91tX+oI5aYYriCQadwK7VnPDvh58eabXaAioR5nNu7W1Rvg0/
         370KVpbMKOFyAJPkitksAn2AVpH7u/IwZaeYVgx+00rweEPuDxctdq/eZ3uX4/HITrV0
         2IVA==
X-Forwarded-Encrypted: i=1; AJvYcCX+K7i9iQFqISWGcpGcLJTakfNu8IggMGTORtv0pFkvLQeT8hn/nSGKHRxatxyz63I7Mlg3G27h0g==@kvack.org
X-Gm-Message-State: AOJu0YxTw/qWsFs7PdauTp15mj2C2Dv2jzJ7Hb1vTV7R7bmDkEUTbeEo
	c4nrTp3do9oQjHP5XjGZuO9xW5hrxlA9GQCwjevGhMep5zndm7bb8THpLCzXsdNkSBhYqT8lrJ8
	LgXu4zjraeZEnqhMJbw==
X-Received: from wmmr8.prod.google.com ([2002:a05:600c:4248:b0:480:1b84:b6e])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3514:b0:477:b734:8c22 with SMTP id 5b1f17b1804b1-4830e92a7a9mr89953605e9.8.1770288707220;
 Thu, 05 Feb 2026 02:51:47 -0800 (PST)
Date: Thu, 05 Feb 2026 10:51:29 +0000
In-Reply-To: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1060; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=ZUybTZ8FVCkafIsHSFbfu9SLz5ANj6JGje2uaPHESaU=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBphHY5UiLUswz39KqBhHpeX2xIwcn8Oq7WgVuCN
 6qlYNhg4peJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaYR2OQAKCRAEWL7uWMY5
 RrC/EACaH/NwT7xKuwuN3MecASBmi9sF5WLKGr/aOsN9x+VVGOQWNcCz930/ZijztwT5T197Til
 wSVJS5LzKRV6rWMo0D7Vo6S6samyRUH1a3ZiDMa/giFTTrQs44r/Ph41BzSfPa0wWLOzBSaYWuU
 AmgMBo0+NGS9nqEOgTIGNAbxzSuMMVXvT6c5TtGeckYWfZ6vFjt+yI/jgsUhxFZ/jSCbUV3f7ZS
 kwbX3KgW3p6gbT+VnRci3kOwssFbZ7sNLTr78qtwmbNvI30b4v4jEUuU/C7parTf7LMIVzCqqDv
 nBta4IqMi8wqL8Dzsef7IpowXzq/mmV9brjxqUfgo3owxWj9fOUDVlw3fo3QrqrGPir/x03hNcd
 DlD07GP+M15auwzqri/MVlh0HcR/w1aNAqTSjZEM8+owD61r175YHqmlv2FtTCrnPE50VP8ddMN
 FN4H/uPH+K4lEjTHUIs51s8h1NlbGxFti65qOi4xKsTxYyEUI8VF8ceegUm9m8PNI/mBwryG8wd
 LFX/cBaXNkOe4dpuMfYhQqDd1jTzxwSbevCNqa275wy6QuQCzbCF2s9pKe3G8zDJfDws5QKM5bL
 y5oeKQkmFafvjThVLyen/QCXN5pIFkiSVDUETMSZE6cp/hmCaPgrf85ZSqIxz//JGZRhBCtPERL HEaoFDqsHlGyvQw==
X-Mailer: b4 0.14.2
Message-ID: <20260205-binder-tristate-v1-4-dfc947c35d35@google.com>
Subject: [PATCH 4/5] ipc: export init_ipc_ns and put_ipc_ns
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: k6bprq9m7hfftg31hr9ugnc7omzg89ri
X-Rspam-User: 
X-Rspamd-Queue-Id: C6B28160006
X-HE-Tag: 1770288708-385843
X-HE-Meta: U2FsdGVkX1881mesSqtvlvRXe77IlUPHbIc9Vh1CsUAuu12R/QyWRcr+rWkvFqNbfBIwyvIFmsOBImltTbCMbBOT1keGcfou8qeVPr1zUll0zPBenvQoQdHPtghDuevGJQyg7Fpj/xUS7pzj1JBXLjG8+4JuyDQt7j6oAysQb1TfOTuzxo3ejKwxR/de5jus0iNuFJ16xb4WYIv1aKARSWSHyTS3WLrS3mlGYzkuf8lab14tqWJ9nUXsBWGI+/HJYYWRN/Sw6cb1lCcpBt4lfD7yfr1jp5H53TEKk40O3dbb5/FHs82pDBUEGjL1w6dfXe5mF0U44Wj7QAVd1KFFw7gWh8CUxowkITaUFy6f7mYrMJzrP5hLkLP+E6OstZ3u8wDyEAV4Bx9HIr73IBDUaORnEhNzGEy1BhBgxraQAiBMoP3jWbsOEqJ87A0+dphZL7Ix/a98TV+L9Nt1ofWVP3/PssXuyD4Mw2Jsxp6gy/5kIumajvvPp3Tm4K2yeWL2bVJ8SDXB2g9rZOt3QkqwhDsEi9NAB03z6lqVEogD8NppsGbBx44x5IGTyv4RShOXeKAuHD7I0PPbi/gZPp79muguo7eguvFoYIzmB5DVQap4mhItV1G8cJWrwE9hSSLqh7UzTMGspwi9jp4lxpY983d5A64kkw5Gn92ZBNPcMr78yg/O0OeizdEa05IzeWl5QaFWQRSuCcmaT6+VpZWwAOIZg1NJUa9koZEWZytc3C8/KLvJwTSbc/sIew6fxqWACH6dpGeLKu0k7N9uJJ9apc6KocJgWgxi0/lQrMjJKq7BN+/tZHTerBAZWVQ8SAlvckmSmD4bpLni4Ebf7YDmwGMOqldANOoasyBYerbN/0ya/yLjD1lGpHsr6enhLKLnX1VmDFoHZ7hyftDFCHa2+t18JkuwtUZ+5UcJWJiaGDoj2FIi+JyGfY7OG2hVueRqI2qFenYos7DP/eEcZHK
 ZJxNZ4jx
 lS5zi6VEZVSdiRpHZAlZehGeyqTf+QzFOYgvosgmAu4MXqZdjruCKvRjcHcoZlCecg9by5Zm5HcqQ9lsPXfA7Vv9MEAdYU9axf9lM7LzWuWfnfm50joSugs5BgQx5dR09OaZsZztnS7xs6kJ46OMlcfxm32DNAw1tADUwKIFj1lIkesN3ariFT57Ca54bbRIdhbqPb+tG3LuSxQ7XjZzwI3I/8HfGOridx/J8e623Tc+61TCtjPM05DJvC5WoTho7Qp60md3o6/vZYnWnlFp7hp/G/WpgKtotAaCrKBu5NRfigPY48dt42YeFYqRc/un7CkoAG1YqGFg7WWOq2uznoDy9OKJKCUX4TbHEB+1FWm4nd3JRh3NN0bdLNxzqA9RIyzTlNpjtX27lhIS/Erk+iebKsIr058YLAX/selXwGetreHpJMd06Vrxd9j42kiXTG9dbsZHPJnzz0Hmadsz9IJ/7GWMAj4uBYZVPbrQuf/x9fh4D2gthgc0GZl1ASTGwn8EsTHlZFYUeD1K5/tABfGuRJHdo2uM+Uv9yILQc+FuS5kp0MYyVRr218yYnqBnOM3zvEsh2uRDLyPAL1pr9e9Zh6vW08ZzeboxGIYbKvVqv9H96SQL6JOX57MM3aQBbrcUfujGa0wTQ9A8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These symbols are used by binderfs as part of the info stored with the
file system.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 ipc/msgutil.c   | 1 +
 ipc/namespace.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index e28f0cecb2ec942a4f6ee93df8384716bd026011..024faedd07c333b23f1e8733833b84ecf5aed9a7 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -30,6 +30,7 @@ struct ipc_namespace init_ipc_ns = {
 	.ns = NS_COMMON_INIT(init_ipc_ns),
 	.user_ns = &init_user_ns,
 };
+EXPORT_SYMBOL(init_ipc_ns);
 
 struct msg_msgseg {
 	struct msg_msgseg *next;
diff --git a/ipc/namespace.c b/ipc/namespace.c
index 535f16ea40e187a9152a03a7345e00b6c5611dbe..c6355020641a74c3be7737b9da15022b961d8f2a 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -210,6 +210,7 @@ void put_ipc_ns(struct ipc_namespace *ns)
 			schedule_work(&free_ipc_work);
 	}
 }
+EXPORT_SYMBOL(put_ipc_ns);
 
 static struct ns_common *ipcns_get(struct task_struct *task)
 {

-- 
2.53.0.rc2.204.g2597b5adb4-goog


