Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F039CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EE8F6B009B; Fri, 22 May 2026 20:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678B56B009E; Fri, 22 May 2026 20:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CADC6B00B1; Fri, 22 May 2026 20:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 393866B009B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:45:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E041A1C1D8E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:45:57 +0000 (UTC)
X-FDA: 84796842354.25.B449EFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32E63A0005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:45:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYrP9ADM;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779497156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9Ii4kFnGASPrJVUv4pLJyz9ASaQSsUSFT2aMNSnQpw=;
	b=yrorGDwUYkEbLKkNzcvXDLh91GvZ5gmp2HZ/fa5MNSJnj1Cc3XzM284sd2nvYUitmBdgfi
	DI/z6jr6Xm7eUt2H1hUvHEfjCS026R0zYYBoa+QYh7ia1nJQGLK1wWnG+0Tul3fJCZQHCY
	v+dBMRp8HKpJpAXZvlU6vARV+tbHMg8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYrP9ADM;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779497156; a=rsa-sha256;
	cv=none;
	b=CRI+FybO6WfggzkXLP2g5/UxCemXYABPkjKzmXuuIN8MoyFFk1SCLWtygVsRikPkGnCpwU
	MhU8cpqPL55bCKlSwcP9GIDGJkg00bl2Z4m2/o4ZA1IX0iGKY+d9Pb0/rd5O7/KTGpfr1L
	M4aC30PoZXuxidTWbI4TxnjKENwAWOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5E3542A04;
	Sat, 23 May 2026 00:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8D01F000E9;
	Sat, 23 May 2026 00:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779497154;
	bh=Z9Ii4kFnGASPrJVUv4pLJyz9ASaQSsUSFT2aMNSnQpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYrP9ADMMstpZMK07X7RJX7Vi+LssxAckCYKP0qcdmy4tA9a9uGeNKXekQFeMbDY2
	 LDBidZU8qfyCeiIO2lTcwcq4IenY+1Wd9qlBghobsMk+v2M/w+YRP79CHe0dVbDprH
	 6m4cKDcu9eoRxsj9K8pW3klTEaPK47F9haaWHiA44qhhUhE1d+q0p7agQTc1CqKY7Y
	 TIm3cavZyfg5Ocnp8Ulrf7LvNxFf6kEk1G4wZqQ5n3xAgZSAUkznMwff7nIEvl1Awg
	 MCkN/vkTJiTtDyoIlmLFKVmTKKTBPE0rS5dN7mvUamAdq3cIcL7ggZ6AdKA3393vQz
	 kGvcVXqs9FgPQ==
From: SeongJae Park <sj@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Corey Minyard <corey@minyard.net>,
	Gabriel Somlo <somlo@cmu.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Baron <jbaron@akamai.com>,
	Jim Cromie <jim.cromie@gmail.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	kvm@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	qemu-devel@nongnu.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH 09/11] treewide: Convert custom kernel_param_ops .get callbacks to seq_buf via cocci
Date: Fri, 22 May 2026 17:45:43 -0700
Message-ID: <20260523004543.86540-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521133326.2465264-9-kees@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xm8aeo4yjt557zt87xzfr1ucdq9gshnd
X-Rspamd-Queue-Id: 32E63A0005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779497156-959487
X-HE-Meta: U2FsdGVkX19CRhNPmYb7qGEoJA78NooY7fBkEBbHjOImhMHxlZpgtS4JJ9ocJ4oW4qh4IG3gNUZ9pbcQyN8ptN00RTkFBQMKw4GQjR+gIcLEU8HHCHRodNj6Nw8g6suj7YHZkgUelNmEU8411mvkgLN1o5rUxE+hQKguM9XXeGL8Y5RLG/Ps6q80115Wz5PG78FNyeZKM29OJUnFnuKshEV3KNs4TThwj+mTXV4bqZn27hEvEjvR8i8qfozXEXd3xcXYncOWZeXtKcZ9+Sm9BhNcAYkmsVkglbVQv0OrWCLnzAJtwrXD+KYH82C7uhIyzzTTyGuV7NDGPc0+DNmW/4yuzeGgtB3ss8VDtR40NKvNiXUKdBa8PNYh+XFAjT00GX+8jkjEANe/x9fRkqE3GHYxMkVZHHY/IeLd5z/x2F6mPzP6xF64G0sfRF+wXlVKZT9X32CbKdF6YIpjt41KbYUHjAfcO0DpLPVm+fWuPFjKYD2GsHXUEVwqx9xFTAq+uE9G01Ui/gxZUHQVBo4t3ppplUnp1LmUrV4FB6fQEpcyS7Mdc0aEDbKzqSclLWD+DrOnaqnAUjWc5hDnHKZqQFKl3eSGjcgpnaOgtWI1XfszTr0jPVKzL0GoTBjyMKFdXX47IfLAY/VjEDonkLueSUBhZwSeIv0dJ6C+PFWjlgfB8m9cp5+SNcm4LYEsKkNrLcBP/CK27ydtZbnhdkt4kTBCDgoNq+nd/oKX4YlwohYYJNSIncrM1bJUHnGk9/gm6jAHrlYQ1Wx+UyiYMIX5b6ie0jhaVfXx8MMBficMwJ8Y4grQ+qyjn7Czqe6EoeI0AMgXUCn59mUXqK5GcVAUxAvWHT5ZGfVDlIGWMBmzEjfWxxX2/0aKJ7ebF3P4MNBL9RJQpRHIJ/7pNYcz1BzRSHcfWNhGKMt0TNofhFdlCDXVWgIH/uOR+udFhkEtu226YK827KFg7VKwcNu4kMe
 yKHvgoqs
 IZZHSGlXns8EQUdo+ous5VgoPeTa57Isb3DijdxN2MU5+sEpsPe6Os0cLXe6Epwxn18dHYzImGRBngFDUHp8MHDwIvf9xJJCZLVI05XgMNG4Y8DrOln7WDHcDSW3HeLcN96UzUSsbyNWoU/HZ/idB5Mmu72YZYf9RRwmGzDwJ898VD+Fhu+j5RjcSVmymdR2V/W9692Rb6yWReh8v7fDOuXZeZ5F1rtuFAZNkjM03bVY1/bxuI01r+lvL+FbJ5yX6Hjil5yAmKuEyyC1VF6CNWe2LOoigc53VQHyhCNuJaNxdI3iQ/mHx10/yQrA0G5O3ooScV+1z2Dl88p8bItklpcKg9dHDv6Snoeju
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ damon@lists.linux.dev

On Thu, 21 May 2026 06:33:22 -0700 Kees Cook <kees@kernel.org> wrote:

> Using the following Coccinelle script, convert struct kernel_param_ops
> .get callbacks from "char *" to "struct seq_buf *" when the only write
> to the buffer is via a final call of scnprintf(), snprintf(), sprintf(),
> or sysfs_emit().
> 
> Since seq_buf_printf() will return -1 on overflow, and struct
> kernel_param_ops .get callbacks are expected to truncate without error,
> we must ignore the return value from seq_buf_print() and always return 0
> (as the length is calculated in the common dispatcher code).
> 
> @@
> identifier FN, BUF, KP;
> expression FMT;
> expression list ARGS;
> @@
>  int FN(
> -               char *BUF
> +               struct seq_buf *BUF
>                 , const struct kernel_param *KP)
>  {
>         ... when any
> (
> -       return scnprintf(BUF, PAGE_SIZE, FMT, ARGS);
> |
> -       return snprintf(BUF, PAGE_SIZE, FMT, ARGS);
> |
> -       return sprintf(BUF, FMT, ARGS);
> |
> -       return sysfs_emit(BUF, FMT, ARGS);
> )
> +       seq_buf_printf(BUF, FMT, ARGS);
> +       return 0;
>  }
> 
> No struct kernel_param_ops initializations need changing since
> DEFINE_KERNEL_PARAM_OPS already routes the pointer to .get or .get_str
> via _Generic based on the function signature, so converted callbacks
> are automatically moved from the .get_str to the .get callback.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
[...]
>  mm/damon/lru_sort.c                           | 14 +++---
>  mm/damon/reclaim.c                            | 14 +++---
>  mm/damon/stat.c                               | 10 ++--

For the above DAMON changes,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

