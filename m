Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1282606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bacsBJQY
Received: by kanga.kvack.org (Postfix)
	id 904EE6B05E3; Tue, 27 Oct 2026 13:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D0F6B0713; Tue, 27 Oct 2026 13:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756C26B075E; Tue, 27 Oct 2026 13:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45D7B6B05E3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:53:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B24F9120A79
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:53:21 +0000 (UTC)
X-FDA: 85369153002.16.39C3E46
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id AB8684000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:53:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bacsBJQY;
	spf=pass (imf01.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793123599;
	b=ZZ0wzkpHf9Nzu45P347Map6MXPMQ8/Kq2R7CK8kPPaz4wi8CGm55eO2B8uMdfo2XDAQf9h
	EiQkMO4/0N/K+v8oANcrI4bDvW9GJHoIi0GWa9SosPmXI9yddTbw2Q+OIVUMlvkSMwldnv
	RteP+e9eYjhhCy4plROliurZ/tj3g2w=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bacsBJQY;
	spf=pass (imf01.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793123599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
	b=UiHL/eDL/AIdBa4gZ0N/AXrhberj9tntvE0akGnB1P7ObcXGLbtXIlX3v2pd99C1/QUpTh
	Tnbe73SrH8AnlYhdjlETyS7q11smbsZO9Lcnz1bkHboIEOJ5ZsMMixTqCzRCYc/KW9pVts
	aad9gf1XQYMd0tocT69thlWGwVC0JZE=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c46d41f6af3so13862766b.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:53:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793123598; cv=none;
        d=google.com; s=arc-20260327;
        b=PsEvDAQHROM9QSAFLZv/IQCGi7CtZiMTLAbvhUU0gNVLxVBq5abx4MqtE3rBVVtsjX
         P9my5BVmc36U2Qd4ji331uyRqjxvJ4/AM9qDKOWA61ie9zfSB3lAfGoGqKL4xOrBoDy2
         K0StoFvjZUFzRbFB2w0/R8gtbi9B9ryt5EHIL8LwIYi6FLQnCJ/mULsUhSE1SSaIXA4v
         Yu+nLlSVq/DxNXRsYoQLmDMVut51/0AQTNhzYmidUyyJrAFja+fVbnKWLHbO4vLJ4JsP
         FcGHb52z1uQzNY1kZok38d9RQT14N5f0NrNT/Hc4DaohmHpTeqLbmAhk6+o2UYQrTQt0
         wyeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
        fh=QTuXPWNo08QtQS70/Yanpit8MHyqaxCmhUF8GcCcRMM=;
        b=AQxFa+Gj/CgjU+8SefUxvBueAyTLFKK8Cx6i5+4siqyRPyPzcBlZAzeif3bNFDQ3wb
         vLGyQfEjrts0ycmEXT+XSediIVP3RGKfCxxZCQ2CFELOGp4/f3IetRDstys0byogR3ou
         pRKeObmE1PmEGrsbVCBONAcfLbNqy4Ggt9YzahrtwytYCjIFB49C+FmVohShQ0kyOEHw
         A01EkQupFAnl5v6FYQupD0I5I0dfXJaKMsYdsFusFYmN/KYnKYp9Qq59TUNdIDJHRbE7
         6k79wsXzL5Te1DqpD5OOKVxxSOtCBIThPK+NUsX03YMzB17VO4dfdN3ofkg+AprA9lsD
         6qEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793123598; x=1793728398; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
        b=bacsBJQYf6HFp9njL0LOt2yPteU91vY20EfJeeQ1CdIbOnFQoS+J1rM85OmOR1l/S7
         8B0nLrZbxbzjzIarnLB0RmHAEvqGdhsHgQYC+2/iUFVVOE6R5F+48sxi0oe/ktjOwvQH
         rl3pw8+lHtBqP1QfqQoKcQZQJ+q1YREUOSFTJmNVQNArO5TyoJG+kE3FHmWDEubny0dw
         r8ZSUqf6gOkYTyDJpaBLTj4aakzIY6w75aCrvPn2sM4tn4uKYPEsAi63Nm40BCJM930s
         gScwf89WwfkPkBD+QTa5Enja8uiazXkcwho/RScqOG+JNOKh98tFRdVHB3PtBniPS9Pu
         RS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793123598; x=1793728398;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
        b=dKXZACo0Pcus0JwWUWFgFsv1i4544Lv/CjL1CtjOUn8Ng7Fbcywy1tnqnFKChB1S2j
         VZvKQpWyD+WU+ubh/tr1EIkC1oXOruBP19RjH9V5R0IuFnMPjaAYnr+10IyMyrqDLeh/
         R7tAg6gXBAHkxnWVdRwPYqJn8RqPJ6Wk3XjMm2yMftSRXUemdWuCPlr9nlzihIy0nXx5
         V1kxW+ONWUQPAN3phTS/uz9vflr4F4QasNwj3itzbn7CM4WsdJuvSGMIbdG/w1mZZ0xc
         yDJvL9r3F7Y3EwsCXV0u+gca5C+qHrT2GiZY6CwQonnmJS9xnyNLEod2oiIuEaicwfQn
         VphQ==
X-Forwarded-Encrypted: i=1; AKwUvBwLOill7UGZBM3ZzzLTbP/VPLQjt3F1eWXUdwrhiNyiCYWqwWszxxlwzBqzBhtKpcM+tqcZExaUZg==@kvack.org
X-Gm-Message-State: AFq9FYJ3WbkXhT+gJwKDo8ZczUB//6bE0XvZhi3ywiH8a1v1O5bni7XG
	MWpZ6LRqYqpfwK654KDWuVipeUkkE7XrdxytVISPFNxTbGEwVWFNG+ACszcHO049icARw+K4Lv/
	liGBu8s8OJvq9N6O4dIBttB2NoIZ7s8jC4xuz9aJ4
X-Gm-Gg: AYBFou1c4cewP3poE2GbOVkeq9QRY0ki+k2KP4iD/oaa4W7okNUt2+eZS3a7+y5mvQM
	xJ6rz2jqO0cUAwVa2EsPpM7dv/mcr9lWU5D1sJrD9cs1QsZ+nHQLoshFulL0Z/tYI+7kF+GZAVn
	OqVN/Qpasw2awdFNg4BYurLTFjfhdZ9OiAdRb0OxUqcpOK+RzfhAE1ylyZWl0BllLypL8foCH3j
	xguURcaEmZhDgGPmvfRBCkkilMbDtLX4LR3SfjuhZWTonkpsCHPlOu6rhDo1CK5Xese68r5mqf/
	0VK51IuJ4DFFfFgihWEqmNxRSDpH3xief+HmOqexbJv/SyAaSmc48PaxeG2pH2xwXxP8PXpg1CO
	+IbGSqHy2I9+GJoRsFsW08vq8b9cWbAbvrt4lV5o12qwlgrYXLIjCgBZM5ZadkSYK6V1xFdRYdv
	iSU0ZzpJBWLBywcU4lFGZj41Ve1JqIlcdfOsd5jjW4/NDaCn7zTY5nktGd78/096GWb4prsSk7y
	OrF5fRM88Exqg==
X-Received: by 2002:a17:906:dc8e:b0:c31:e958:408c with SMTP id
 a640c23a62f3a-c46bde8b464mr1159692166b.38.1793123597614; Tue, 27 Oct 2026
 10:53:17 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-2-jthoughton@google.com> <1ee97e9e-3658-41a7-a879-348f51ab547d@kernel.dk>
In-Reply-To: <1ee97e9e-3658-41a7-a879-348f51ab547d@kernel.dk>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 10:52:40 -0700
X-Gm-Features: AclHuK_7gnb7g4GjAy_SA5zcAxXhabVZixR-oCAtO-qS-tkfEqOEG_LlV9pvyY0
Message-ID: <CADrL8HVgOYb1hzWDJzm4sCrEAR7PL1xBv-1zTGebTusPoDsGXQ@mail.gmail.com>
Subject: Re: [RFC PATCH 01/10] scsi: bsg: Don't copy sense data to user memory
 when canceled
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: q3y6zqbxhneyfqjtd3czz1jtup9najua
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AB8684000C
X-Rspam-User: 
X-HE-Tag: 1793123599-664849
X-HE-Meta: U2FsdGVkX18KmJJN5cA8KT4zFy3N3pMdDNwnQXFQ1O1BE6vWKmi8X69EVp8AvBvJsfHgOZeRuyy7KbDzvVVZ/Z/h8DMQmo3DmLSyGi9Xvj3nIgOu2v6u03cmgxw//0jrHQ4+1IBsQsoSV0imLIf7M/A8cyo1ivacp1elH3GJTxOZmchm/2XrITeeaxsG1qdIkFVW3aIdrAbCA/GoTKlETwrHv72Gdh27sq6XBmORPqYBwomEMJCYyQ8gcjmm6fc5zHCN1qQPve9HbDrnhNjQ3nuaHIbyt9UsSBEBXoNHBsXOWQ4QoQ4jdHcQPCAerUhndUe5AUx7qMJYZndz7UB4Bvww/ub7dL6R8ti4IhFHhbZBpctrVzcU0WuUaolrByaQ+MmmAaj82KEKYnT4++biicSJDyWoagf6uYNGnl1Pp/RYSwZ/Izzqp6kqCxf5qYORZGIpOxcmbE9GLGeL/iBAivW+05z85Suq7bTQEMGaeDPkuAsGCnqfSOorWB46HCWN2lvLvOoGZksfBnvP6QwGK/Hfio3LbP60N7v/pHCIaVF0256evmHpCXlTTPY+0/u433kJqYRYoV0vzKaUImgY1RtxNTQxhYw2Xz3i7LBlZbHDmCA4aiug0ijVqiIU0QBS0D3woLR6MayBCZuos1ufoC23zvI48FewJWGfJM9xhyDDQt+xpr37vsjBqK2w29okgy46yYykpYv1xmX1dzknpPwQUpVTh19qCHJy70gBc/dOIByzYXLxcdap87aIux3WX7VePhFY16tYwgUeO3gWGljZP5ZCUU0FMf6QCF20uYryOgTcvve6whk/1lbON4C1movdEv3pOyDO3pOV2cc6SBcLB9fgwaifEUnqhsByW9+pYdGmVkvBm6j80pFOefleyoMwiU/f+KNyhJo/I3yS32vAH8chu6VxkDaE+4ioBFsXhH+E+4zYMpvW64ShX+p5aAkuC30r0rdOXaRe3HY
 /oLAafU0
 z1BzO4axUOwteEEc/baBsxvt+iIw+V9ZQstyHYwz5rCcHmJWUe2evpyvGoYIRmeuR5EkTLWb0zAiohTGx8fLrPkoAwwCsKCtCTWCs1GI6LeGmCgc4A0+BlMuTLRlPnos98jZXu0E27gRCTKnh5v0AuS/IZ2onxLz3NJTBGCP/vF+Hcdq8dXgHu0xacOxg1Q8xwWTTOw47PIFUUeZqlA3vnuerHOkihkUJjFdmb66fup3vrD+x28coK5KxgwMc/pbVu3ZiCIx/yTrTAcizSStCqw4ePNl2SC7RokHKxvHnaoGlY/uxkWWY6Qzso6JRjLFBDz/yRysDme63egaRGlMje2Vy0VBsf6OwPJYN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 7:41=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>

Thanks, Jens!

