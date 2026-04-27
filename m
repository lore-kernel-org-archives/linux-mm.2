Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B34FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4517F6B0096; Mon, 27 Apr 2026 12:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428DE6B0098; Mon, 27 Apr 2026 12:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33EAB6B0099; Mon, 27 Apr 2026 12:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21CF26B0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:08:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBA07120C27
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:04:09 +0000 (UTC)
X-FDA: 84704807418.27.86071D0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id F2281C0026
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:04:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YK2gcRkb;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777305847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yljwN6KCpoZ9u8ZPW4Plzy1QSibJM6+pSoXgDh3CAaY=;
	b=bSkUYk9zcpkrHxyLvBQhSNS83YIatr4NM5jPO2p4JW1ibbiDN9LTJX9sVZcTIuduKStHxE
	gxEA0W2Dgp3iiUm/gXXgs+jEJLWlK0XBFfvGXiOV3qZje4Hz3gVd+RGIDF2ZrAdD9GVXRu
	go/SUToeFlO5UyWcMNO5aNuiWXy6ZtM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YK2gcRkb;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777305847; a=rsa-sha256;
	cv=none;
	b=jhVXMMyVX1fgzU4r/vGzpnJ12hVBFeQ6MZfsoqztWEh3e41FN5GNcKUk/ecnOCofupWJ7d
	UwwNwUb4DhLd9QFlV15N8o8VZRgAxJTKzjCdWqMMHCX76rkJZlVqm6v2ZvN9Uq25WsMrm3
	k6JjOiZ8VFELXW9ap9rhWTebyuGKz0E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777305846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yljwN6KCpoZ9u8ZPW4Plzy1QSibJM6+pSoXgDh3CAaY=;
	b=YK2gcRkbuwK6VqCrLEaw2BA7UWtx3bZpow5KzSXjkgUnORhdgBxReW4U4yML5P5lWmjaEx
	DbAua7SvxMHzNvWbiQfZ7t3gIPHzdGCFLl0pJGGLJbeT8ZUcWe9yPM5VkIDwyUsGi7jQ3o
	Ymwd8LA+f1VGOz6qKjEedfhx4XLq+iE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-Hl3QK6lDMI-v0cDUdpwzLw-1; Mon, 27 Apr 2026 12:04:04 -0400
X-MC-Unique: Hl3QK6lDMI-v0cDUdpwzLw-1
X-Mimecast-MFC-AGG-ID: Hl3QK6lDMI-v0cDUdpwzLw_1777305844
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50fbc70cfbdso156072901cf.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:04:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777305844; x=1777910644;
        h=content-transfer-encoding:cc:subject:to:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yljwN6KCpoZ9u8ZPW4Plzy1QSibJM6+pSoXgDh3CAaY=;
        b=lZoJVEyXL/s6M17gbfg8V4+a0DZXy96AwT8RUJVRgi/vP5q9RyJZKwvbaooVcL/2pa
         c1q07Nr7738Qs+WgBHd7XVRB5yQjto/eMhyTaHRM9aRD5yNWepWMZpr4tEKlKkDpmfIO
         W3/vIRXNIiIIH71FAmWYmg22xAG0z7sgUIgER3HOsEsVo3x/kzU0rJoUjVQeaLnhb3h8
         +Kx6AYxdN3efmLNr3jJEN1J7aRZJR7pjQKZD+CmP46WLrbmQl5TslharTO8G2vcw4ZQt
         vmLtKAPGx9g1RXr5EdC2Ip6/O0k8NVEWk/OCNtWIby3Prb3U2dbBninNN8RIUOPdWE46
         +KCQ==
X-Gm-Message-State: AOJu0Yw9/hzE/Fpom1wygzwYdPXZ3QMhlW10nRiYih8yzXjRc3z90VXW
	Nj7HhWTs5HrNySr6FfLYIyEM6UMgv17K0wiOY2WThalaF/45gykGgk2qyLAAv49BL3akXaHir6x
	C7TiemEndFfrOttDdJIBANhOdINleuzS6bUUDBsYQ9kvZg5iTF0YuZErySpEnumjHsbfqlE+sXB
	yidgmdrv9NpasPUa5eGFCdNQL4eLBmo2q3v7E=
X-Gm-Gg: AeBDiev5wZrnOyskbXmLZ+seNhk8pwv6bZ58tCkgiVwYtW0yZ3AmbGdXfLzEfAV/N5A
	BQgmxcTPxqSVL3T2CzveQqH7vfvw/AWqHTOotwOMXc9ETrYKVUokuDFP72O5BfrFcN45qztaDuJ
	ZwVUTqdaVA/HhObYw794QlD4rDyo6c5DllXYuHivsG4jXDhWDgfpSVwCx+M75Ts9b6AzCseyLmM
	Gq74MB1D5mAg/DwNXDABcOQP/vAk3UysglBvtB/O6fKF4kEvorsgzkxb5Mmv+UmprXU8EZPnh5W
	CQAoKHkNBCmt/TR8sqx97EATf2FnFgFUoe+kJaIoWo/b94tRwkeDqro1pATW0EvCIYw3a6dV8j0
	+YfQ9BxDKFDb6g+FqcJpSPaGlOtd37R15R9fj
X-Received: by 2002:a05:622a:1650:b0:50b:41bf:4ee5 with SMTP id d75a77b69052e-50e36f1b3cdmr659161341cf.57.1777305843914;
        Mon, 27 Apr 2026 09:04:03 -0700 (PDT)
X-Received: by 2002:a05:622a:1650:b0:50b:41bf:4ee5 with SMTP id d75a77b69052e-50e36f1b3cdmr659160301cf.57.1777305843219;
        Mon, 27 Apr 2026 09:04:03 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e392c859asm338056491cf.1.2026.04.27.09.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 09:04:02 -0700 (PDT)
Message-ID: <214fd9e4-5398-4c26-859e-c982c2e277c3@redhat.com>
Date: Mon, 27 Apr 2026 12:03:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Luiz Capitulino <luizcap@redhat.com>
To: Linux Memory Management List <linux-mm@kvack.org>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Subject: [PATCH] selftests/mm: run_vmtests.sh: fix destructive tests
 invocation
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Cihi-NBy88kZQxslXmEEsL8drLXCPt0FvBzg7MuWTGA_1777305844
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F2281C0026
X-Stat-Signature: er36qqweqkasb1uwnk3ocjpgr8qbmw1c
X-HE-Tag: 1777305846-948352
X-HE-Meta: U2FsdGVkX1/MEYeT+oMk8gsGZCqDu+y1bIG/Ml55ANTVS4876dVoTwdA9WmptOLEOaWEN+ALLDVF+xCpOoBBdN6Tep+XhoKIM6fRa/p+7HnTL5+nhWE8vAuGTW/QVxyakLccg5PZMFePrxQRDbbNhF6/MVI4+emlqJb2rkS2lNZ6W2BV4h+JerGmtSzZQfrdY96maPisae3U6H1xe7houw8cw5upy84yVWTtsC5gR1wlMH2Is61zBNs9dr6laoMP9lMf+b5jyuPwPXuQcQAHyupP08+L1230vHKNxCd0R/Zi86UUfV5NpwEhXDG0G5bTqAgql+/s1HzwR5kg0NHjVfxY4Q7qmmf67XlEwWwVed+ReyAkwS8h098Y1Dskz1aSnkwzR/Nrk5AtVWHhpBkF+XHY1eiBwwuxu/XGQszLNea933bwle1XPbYYWS1G9zweSYF8qKepu6awZKyqzTu1Iiwgsvd2o+SWYm84KuM4l952Lqtafn537RR03pb9hNSqGLSU/v3g3S5ihBNF7Xv0ysC5q44sBKu24bZ9IuxQgRE0dXYYtbv1YM83TKPLdEunTD1GC12Cv92+NDbADgBk4iQu0TDzeZA2GCbdbn186DO0bKQtoyf2rlEDJ68UfIc3UhqDFdqSf2fzsCZbsBmxZZlp3nPnTX8qV0Oud3WXwYmpxxjUSwF0atbctSJPdVZ+P8uykYy9hh3sw4VLQ5aHQtWV/TR/UwBvjnDMJbbGAdkV4w+n33it1pj7kiDdouavJhzG7Ls+b0ff3ce/PPtJbLlodmth4BgqyOiLpuII9E/GfwlZqg4hoFMsydMKOQdNuZp4v8pbYk+bbZDZiEOp37hNQWQ6RIKgf9GVBNtdTWBh+aor9shXwUi+VNqOpzktgNG/tp/UI6/kX4y6QF90y2XiEn/HHKOuH1VjIykTQyA0A4Y9ncHnaxr4PFsFmnz+cQaWGT/Kk6CWQIdkwJ8
 NXLLSxqp
 SarymdY5sJSBiKslMdp3dPrDs7Rw/1TjYtN0qB8LZ7l6Twka0M/ZzHKSNdBQuposBy3vWjEA21OhrLZm+gv7mQqJIwJRPk/UMcYgC6UpJvYnKuWkew4n3kBAzDPsR8BVKwMV3DDzNV/3+sOPSvymLiGfI2ZONfQRuWPzAeVVj7Ml0NxsKw9XdZttLideGCGbXUwkRGNzxF8p80UiVtqEruMj3NchNWUPz9X9GwwT1MHswhq3viX2sHHLN7/gp7BrG53txcUiMnUdW41wq3gTyZU9JV0t+fPYG8S66x5hKjIx4uUcJmpwvpMJK9gtO28CrdieN+cU/+uFyZdMYHVWLsVRdiIe/WkcgDR553kUC6PQjXesg1uwPs4DEBBt1XSmlpr8QDFK9jGNyZBSeDEcpWZeoXUyenpRbiadIVIpHmAt4hwrIR5H5COOE0euw1bOYL8XqrRrnvb5EJuwODeiJvrvAFyKTsWRo2nG1lK5ohpAyxj+qGeqmJdHCzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Destructive tests should be invocated with -d command-line option, but
this won't work today since 'd' is missing in getopts command-line. This
commit fixes it.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
Mike,

Maybe it's a good idea to add this patch to your series since the
hugetlb-read-hwpoison selftest won't work without your fix.

  tools/testing/selftests/mm/run_vmtests.sh | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d8468451b3a3..c17b133a81d2 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -103,7 +103,7 @@ RUN_ALL=false
  RUN_DESTRUCTIVE=false
  TAP_PREFIX="# "
  
-while getopts "aht:n" OPT; do
+while getopts "aht:nd" OPT; do
  	case ${OPT} in
  		"a") RUN_ALL=true ;;
  		"h") usage ;;
-- 
2.53.0


