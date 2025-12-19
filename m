Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5EE0D7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38BF16B00B9; Fri, 19 Dec 2025 10:46:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34B2B6B00BB; Fri, 19 Dec 2025 10:46:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2762C6B00BC; Fri, 19 Dec 2025 10:46:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4AF6B00B9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6BB21A02B7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:51 +0000 (UTC)
X-FDA: 84236648622.27.FA55340
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0189B40014
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="uK4/ELzl";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3aHNFaQUKCLUZgqZmbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--elver.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3aHNFaQUKCLUZgqZmbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159210; a=rsa-sha256;
	cv=none;
	b=lWHRu3F8UsciDCMwmyTMQK9G8Yb7SOwCbTLuRq3GCX72jS3qlRhh5Gl9V473nmw/NCdr8F
	AougFPfhXH3YrXQx9LgDqyNnMQ8aNw52KYpOvl5eRCQpqOf311/V+kYHs1i7zLDJcblKx+
	ZquKkvn/lnMxyTRoY3W5mLkuIVgLuyA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="uK4/ELzl";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3aHNFaQUKCLUZgqZmbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--elver.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3aHNFaQUKCLUZgqZmbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwJwFE4RR+G0qPj93NacKXfc9Bqs8f3KUgfNaIjFSIY=;
	b=vlitp3cbHTGN+mSgZDASkYOL4JgQ2/foXaZxPbSULkBXX4tEyYqj4w4Yv3Anheea+EQScg
	gO7pq9bWrWX8uFboCA5v/dc45S8zDbxNqtPf326PkAiAF6341n3OWp8SHXvdBlMNu4wfbe
	DY2IVOUIO36Vj60yuNqTOSbXD0dv+6U=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64b7907dd42so1740565a12.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159208; x=1766764008; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iwJwFE4RR+G0qPj93NacKXfc9Bqs8f3KUgfNaIjFSIY=;
        b=uK4/ELzljDbZXcEU/gtdkvHp8APOb0STn6FJC8sWBPXC4x5wkLFJB+TebauDt8v3mg
         wpysxdfblQKFTRA9ZTd3Q2axVsYsoLWjOY7TMmwEW1OQmybIItRGR1rgY42Z7RJv+KS+
         cocMtbjBP/f17L/4PEuJ5WAxae32jsfXCzlj8t/YwcybKlSGM5nGslna0YIPGdNdOxJV
         e/DXecd7R8vdp1rGvEgAlhXBn87LHgUldz7o3nJXJzqGRUvMBK8EqnhL6u8YQ4SGdy6/
         ybzMC80Fu5RAVUkLbggUQ0P30QRb3wmv/C1LTWYEghnFlC7m7RMPoFfYdXg81Nuf6IGq
         sHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159208; x=1766764008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iwJwFE4RR+G0qPj93NacKXfc9Bqs8f3KUgfNaIjFSIY=;
        b=JO42yvXgvpU8Jnqb/yhCNLR7Q4sn8X9aJfRHKtP9EhopLe4BMcDakASrlpmTZpQ3Kc
         n2sQYwHAx92vCWHefl60sloca3ELYzMtRXRcaXi6Yo87vFa3+T0K5u2I4txBLRy+iqyf
         n0uSATYeREJkoroQYD2dMFZKdR4yzEHe0LsCJ6f5MMhyn9j5xMPUx/T7iLLwFaIKgDXc
         hcOZdblSDpdGNAVgLg7fRGL2mYZpZIrwQjevXIl0YXajJ3agFkeH109p+YnQIHPL+GJK
         4AuAS2MU/PD2lBJZ4y8ast5I0/Cab84CP47e/LEJ1GkLGzCURo6Pyig5zoPNxsq/21QE
         btjQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4cIck57k09/B57rj8HiKYnH7rY65eSSy8NGtS2wvucgEwya467sV9r421Zwa/bN60oMnh9iIL+g==@kvack.org
X-Gm-Message-State: AOJu0YyIKZumzVQPm8UBHIdsMQp+QCVf7IXGL0dyRVa7cjzKBxe+VaKF
	xaM3DGAQDFAO0OG8UgDTKDxJuROHWHJ5EhXHc96s0om5McS3NXU8wyMLueNrp46u5dJcYXxGqh3
	aXA==
X-Google-Smtp-Source: AGHT+IFnXG6cE34nzlKUaF0YLjZuRw/c6GtHv7aWsx/cCEAUfVEyphXLuEYpLswMSP0zGStw/fZIKiWOPA==
X-Received: from edwv2.prod.google.com ([2002:aa7:cd42:0:b0:643:8c4d:bca0])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:27cb:b0:64b:46d4:5d5c
 with SMTP id 4fb4d7f45d1cf-64b8e9379dcmr2970087a12.5.1766159208169; Fri, 19
 Dec 2025 07:46:48 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:10 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-22-elver@google.com>
Subject: [PATCH v5 21/36] debugfs: Make debugfs_cancellation a context lock struct
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 0189B40014
X-Rspamd-Server: rspam10
X-Stat-Signature: 4fr4mjaoweofumkyechipbfd34k8hemh
X-HE-Tag: 1766159209-224679
X-HE-Meta: U2FsdGVkX1+uj8k+2wAe0QGikGOG5RRqx78iBiNYeav1iAZ9nFdUxvW8gIVs0QFw8KfN+tMDI82NOGPGNgO2n7hJtwxDxJmLCRUKQnchsB6V9TP2jOauuQVw1h+5CvhTc56aWOafCvecToMTOjpc/05Rds6k5+1FZSUqcFtuqpioreSiLWQAVXlO46KjCH9GUewLqp+A2UzpfcJwTvj65RloNgyy/uwgIuiV1CUsUHe1W5hfoxWSmJKtf0gJVeJ49Mr39THqPf/iIB4+ueTqZ4gaW7aPtz/fx1IVuptLSdtHV/y+qpLmbSnL4f64D6GnTCnSzAe9wTDXsB5rwzbtRQ7lGMHduT1qqYLw6jVH7W2y/1W55lTyzUSH867bZ+5pejm5yaDmKwFzu1oXgOKUYH72noMXw/a8w3LhFJonQoIkorKl9YzuR/PFsixOCGNgF2RDc/gr9b446P10gCrHqVdNqpHS5tzWvvL/c311OLr/shDPsJBJDdGvU/DXIPGtXS3sLXAU0/pb4nFJ2vUpsoksW4YfQnxektEezQe6IHoiLty0VRoFaHhpWHUqemFZhS7zLwv9J7WJA6vMvOXV5bu4a/9Y+65agjOoDEjsLZiPYnY09ywM/1ItlaglUGxq20ujJVq1oaolf3pM07WRE99Ovi49lc+TWFKc33UGNbxDXps/8C+Ybw/+ou4gdfA5IPmr3LeUkxl5ad/iRuNsF0awZbuM/9d/QxhcHRueMVfC4a8JbvHNkrj2w+Piia9QKaiCQSvK1op4/heAR51B2tGm229XxIWVGNPueeRYY+3+yZGbgHTU5Zv/LPyLUz4ZPCpOtJVv9JqE2cjK/VhULoa7fDty2ojTh1GNyN3i2CmQ5u6T9Yiul+1ToIQzzd2H66LDnxU2ntx0w7RUy0WaQcW1jBVWFEP+XGcTCAaCvs4IdWG9KphTiv3Dy8wjZEn/7H0vgBERTcokvkgqFYL
 1AomjCtu
 QpwrUZQ2VRoxWwN/Zu/pzrZNtC8f6R3d3N31RmZIhDKN7qps1y66V/1tvhubSlVLM4xJ4AZuiCood3FLoReakGAAzjEzBruKFk6XQ0kh/uRmiR82aBod99NCLOrZWRITpoyQr8XDHDYBJpecB1VYH0gSO56EiDlPLgVL5ClYsgUE8vF/wsllLWGbKuyIp7nGcZmKkQp+hUA50wc/YXKMCvSf/UsD69tO00W6B5gdibJY/cqSAjcqRklPhypvvUTUrmSto8RinsS6kKptm098KuTg8aVYLHBeg0TYQb5cRP0UhDR8t39uBzhBLhueXhT3Kt9CLFAR/kaIuViVB6pQNk4ZJNw4KHf0HniCQX30vwmSiNwnb6SHnRzAtOx9bZwQZRkMXSj0iio0ooa/DK4G9fHBtXzDbhUiCH6HR5VpueqO6FtSv8XFtYPo+EXMOTb7u/gHPSkf15G+X1DjadbilYJE2VYms1jBs1PuLHE8gV24PZPMIp23mpidGsGMK/BPU0ZSFw19PC9xROHvjC8vsnIpXBkwIZcMGRjLalP4kcoW1W2Kh/LoilDh94li3sCmCUn6dMjVLfPsrDORdYCQPiE9dXeuNHJqDZlhX9IO6Ftd91a41lENeg+w4CJhVJcR0Vm00NH9JnWDUQPfaGDGpiLvbw+x36Jk5J4sfhIOAJqGZgw2yRNIZsVXkIKzinDcLiyiZKzPcr1412c1xr1G5k2+IhJjtrN12gIQn+d76F263EQ04isMI3B9blA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When compiling include/linux/debugfs.h with CONTEXT_ANALYSIS enabled, we
can see this error:

./include/linux/debugfs.h:239:17: error: use of undeclared identifier 'cancellation'
  239 | void __acquires(cancellation)

Move the __acquires(..) attribute after the declaration, so that the
compiler can see the cancellation function argument, as well as making
struct debugfs_cancellation a real context lock to benefit from Clang's
context analysis.

This change is a preparatory change to allow enabling context analysis
in subsystems that include the above header.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".

v4:
* Rename capability -> context analysis.
---
 include/linux/debugfs.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 7cecda29447e..4177c4738282 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -239,18 +239,16 @@ ssize_t debugfs_read_file_str(struct file *file, char __user *user_buf,
  * @cancel: callback to call
  * @cancel_data: extra data for the callback to call
  */
-struct debugfs_cancellation {
+context_lock_struct(debugfs_cancellation) {
 	struct list_head list;
 	void (*cancel)(struct dentry *, void *);
 	void *cancel_data;
 };
 
-void __acquires(cancellation)
-debugfs_enter_cancellation(struct file *file,
-			   struct debugfs_cancellation *cancellation);
-void __releases(cancellation)
-debugfs_leave_cancellation(struct file *file,
-			   struct debugfs_cancellation *cancellation);
+void debugfs_enter_cancellation(struct file *file,
+				struct debugfs_cancellation *cancellation) __acquires(cancellation);
+void debugfs_leave_cancellation(struct file *file,
+				struct debugfs_cancellation *cancellation) __releases(cancellation);
 
 #else
 
-- 
2.52.0.322.g1dd061c0dc-goog


