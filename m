Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C74ACD4851
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 02:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6728A6B0005; Sat, 16 May 2026 22:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623A86B0088; Sat, 16 May 2026 22:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560196B008C; Sat, 16 May 2026 22:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4536C6B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:18:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA34185538
	for <linux-mm@kvack.org>; Sun, 17 May 2026 02:18:07 +0000 (UTC)
X-FDA: 84775301814.10.AB8EEA0
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	by imf14.hostedemail.com (Postfix) with ESMTP id 05823100003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 02:18:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of penguin-kernel@I-love.SAKURA.ne.jp designates 202.181.97.72 as permitted sender) smtp.mailfrom=penguin-kernel@I-love.SAKURA.ne.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778984286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=za6Cv3ZhmS8xUVl9kKiOEUuhRPuLoqxPOnHuc9KDoug=;
	b=tBnFXh6PQIN46mQNZcML4ZIVWH7HHwYr/VbGp5yP7YdvHu54P7nbi09OcmMwpcvg73Mv7V
	DVg/RX2Gqq9ODUvimy2i+lr5lNB68DIzd4Mcl70akCjhxzfb2NGtPSLMKhKVnCYh8xb9gz
	n77TOC+Hq+kUqFGPJFGl2xvEU0YeEfg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of penguin-kernel@I-love.SAKURA.ne.jp designates 202.181.97.72 as permitted sender) smtp.mailfrom=penguin-kernel@I-love.SAKURA.ne.jp
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778984286; a=rsa-sha256;
	cv=none;
	b=Zbuj6bSUKqi79/wYwJ5zO+CTSnG0z2n+5cFmrivRuL9JnMc/ToKC1O9boCy5QrKPioduM5
	J6vqmZduBq0O9z2Xff7H4XXB1AuMCMrkmV31zIr37F5DkkZWeFd0JshtniiTwvD14Omdhz
	kjoGdsOE6TrtSfpbB10sliba6jxtwQw=
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 64H2Hx8A075165;
	Sun, 17 May 2026 11:17:59 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 64H2HxQ3075162
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 17 May 2026 11:17:59 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <5acfea15-f2f7-4498-86e1-a383e17adad0@I-love.SAKURA.ne.jp>
Date: Sun, 17 May 2026 11:17:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -mm v2] do_notify_parent: sanitize the valid_signal()
 checks
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20260316151956.563558-1-kartikey406@gmail.com>
 <abld-ilvMEZ7VgMw@redhat.com>
 <20260317113452.cede9a514dfed36a1cb0e5a9@linux-foundation.org>
 <abmmnjgxrrGLKn2D@redhat.com>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <abmmnjgxrrGLKn2D@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav404.rs.sakura.ne.jp
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 05823100003
X-Rspam-User: 
X-Stat-Signature: ne4gsirrqmd6uzwx4sbscoa4199kh98t
X-HE-Tag: 1778984284-775844
X-HE-Meta: U2FsdGVkX1+6F82+Ps3regpzzl97QIPrRppz9VipQiEmhcYHV1yVaGAROjUaeON3uz+VMFe3bs1wW2KxV6WA2r7vvFz9siS+KGFIdBmD6LnAPiumVFLGhTBptNBbAhBn7+Ymu1baI7RVl655wdtwA0YUxTm8ZSV7HYrXRKWixls5YU1L7LExDjaCT4zFInPAwB7HqzXGe0MhizD6Kle7T5y529ded3I8hK4VsdXyRO7njsOXKtIkjI8APEkEvXDEwPN3Vhk3jdOfQKzeJ3D4PL1jmzd14m81EAeRsIDO/pIVcXSloFYNFAZc5k4bEkJT93nk0zk0vsmcBd4VgyoRPS7Dyi+pCwKlg04Wpff5V6jDEkjEto0f32zNDlRef+o30uygs3MKRVitbVHXRKJveEe7Uk4UGL6+NA7kKfnU7cCLKk4/IQymjfsyQ687uVEYgq+MP4p5GsM9BMPT32F5zyF9sJpmEgbauOMzYylxmfuMbIneg5nTpagFiipJ+pbNsn27iVb+rgITmx1oAwRLlSkmMunZrfFIiJA7Cxud2UAoQ6Nrc2N7F78s0KkdKM6FFH2LFpT/F9vyg+KBwGcpi7e6IDyMGR0yxAcOaomxEZHfTymqDaalm5He9zvgbZZidfbcPNOgiR9ka9jgeBcmCAyNdnXwynrlKb6sIlsfcwXMGzZ+LL3PRNIyziXJ8e6/MdlKtTzwjQ485fp9C3gWz4DEZ3Vtb8aOmido3urR/+o0SMY+uA2E/evgBbqc+FhAYhNLkXffIR9kPWvMEwdtTF5pxZopygG5kV6qiEEVREpaHIwHXZgmxm4/234TAoIzWXnKhviz5dba1pJrOogPgzrHNv6qHMxEkdiSJh+6JAjGjm/e2mPUQa503aoya07d0ASOkuIH2NfOJEOJlO/ghlPLKpWbzRMS2Wty9jAzDUc0DGOmI+IItysMQ5PKTFyO+gfPOU6dOp/amoLWzNZ
 0CIQTv2q
 iDbA/paUUwGcgK4RBSycvw0Qgl52/KYnKq0Dw7Ka8O4HNgtApEJkbAi2QpewJUjPUt4dyGWONkXIZJKpU7zZXAO2WZqe1E+lhSH2O31EH0Sf94UHRVePdP0rxOf4dBWHPniTVIWp2WnIsP/2z4NIW8Z7gJX8WsFGzcXsRUWIcSvNIameuCvDDuR4+rCwEuzNnvrsRC5RfXI9oAv+vwK3E47AvXle23UdZ7Kc8BQ9ab8JjO3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/03/18 4:08, Oleg Nesterov wrote:
> On 03/17, Andrew Morton wrote:
>>
>> On Tue, 17 Mar 2026 14:58:18 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
>>
>>> Now that kernel_clone() checks valid_signal(args->exit_signal), the "sig"
>>> argument of do_notify_parent() must always be valid or we have a bug.

No activity for two months. When is the fix expected to land to upstream?
This bug allows a local unprivileged user to crash panic_on_warn=1 systems
by running below program, and therefore should be fixed before Linux 7.1 is
released.

----------
#define _GNU_SOURCE
#include <sched.h>

static int proc(void* arg) { return 0; }

int main(void) {
        static char stack[8192];
        return clone(proc, &stack[sizeof(stack) - 64], 127, 0) == -1;
}
----------


