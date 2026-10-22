Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208A0606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 12:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=iS4CVDDR
Received: by kanga.kvack.org (Postfix)
	id 3A04D6B092C; Thu, 22 Oct 2026 08:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350F76B092E; Thu, 22 Oct 2026 08:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240086B092F; Thu, 22 Oct 2026 08:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF15C6B092C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:50:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BE2E1A07EE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:50:11 +0000 (UTC)
X-FDA: 85350245022.05.5C4A647
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9B974C0002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:50:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iS4CVDDR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3fwbaagkKCFIDuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3fwbaagkKCFIDuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792673409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opPc+eRANnsL3IgwnH1KHoUHY5QiZX1lM2OixXujM5s=;
	b=gm55B46fms4EnhsKbgZgJVUR+qo9HqggXG8UJw/29A4Mw5r5tRGRGOVS5NJ6EITd8D8TiZ
	B7djvt5Sb3Bpe9jpA9mxIxwZwvGYK7wWefXcH83Zo5G66U3h2BKMgXola7SBjnp34Yo6bE
	SchvcIgfoYuo0zAfr8/WwByHrv6lo6E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iS4CVDDR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3fwbaagkKCFIDuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3fwbaagkKCFIDuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792673409;
	b=Wu63XoeTg+IJtSCTyx4CeEcZMFWVx5qzztK32BxpoYW6uXoG0UcytrZyHqwalTEBe0pfCr
	vyXLQk8rL/PymFQvjPLEH8bEPAPLjKP5MRetT/cRLzWYT6hK7LwogwT+c1/Jc2/dyczXgP
	Bjq11lQs1VICeA5358dzZbcswIv3lw8=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c42888c50c4so146135666b.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792673408; x=1793278208; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=opPc+eRANnsL3IgwnH1KHoUHY5QiZX1lM2OixXujM5s=;
        b=iS4CVDDRyzwSAZqxTAQO1onNLqelz8E0Sp7hGt7SEYJGQqjZMv7Yqk2evwqf1V0kUp
         Ibq+TCQdLDDaqIeuHJY2tcQMZillsFi7aRTznos3Xceql6+YnguqOzI+ifetQjydpJTv
         eivP+vSL5XnwL1UcoMx+Mz1zRqK2THsgpIh+sjBBk3fpZSjpoDa8C22om9GJ2fd5XSe7
         fzsK3tmQNI/Rhfad3PLdYO0sF9fbktz9B/XfP1h5uA3Fua4b9jvGbxve1/F4QnD7o4XF
         awhNLURTrL56f5LmEYjQtjaF8rfPGzmGic8Ao3yeq147P/Q1IlSfeCwS0GiIKSVhlTQI
         Nv6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792673408; x=1793278208;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=opPc+eRANnsL3IgwnH1KHoUHY5QiZX1lM2OixXujM5s=;
        b=cO6SG/lQNAcyGHfyJzu8RQcd12kSFqGEw9WyiIQuaxYJTELnbMaCDzGqIKyyHyNkTP
         VQzvDkuYQ41ZaJBSnlkTDt7McuOh9SjM48+8lD4EJ+twKcsBLJRNDMqzCMDXyyatBJCb
         NQQZDu7MzvsM4wBX/oS/Cm9qV0TZ1Ujr0cVQ5CJEvL2O2dJLjHcwASCKqymVW+J3q4At
         3I8Bu4Ch2tTqWUsPvlTDe1INPVAZxeuY1HPP0sQB3G4n5lpo8voPTcD8yHSx4RBdZTSj
         iL+KKC06WNNlObqnrcy86RQlgLEmPCnNld+MR5MUdiEDGCE+VzwntY1ZKBWc8OT2S2DN
         fXuw==
X-Forwarded-Encrypted: i=1; AKwUvBzlq0mu1E6d3LepPGSpX7awkYxnQpC1uDuky96LiRK9wdUNRYGhDDjCAnjjjnaicizMwRVgrEoE2Q==@kvack.org
X-Gm-Message-State: AFq9FYI8ZJkqoG32MILmqW6nAQYDpyPwl7XLDVG+MEpvhY9ob8WX0JW3
	KWC6vGhuD/KZgMTyY/oqK3ei0J5TM6bAPa71tz9F04QDk1GZBs1t9LYjM1eGAqEbz/jWRfubwpz
	ge2BZEeF2MlAJPo1Dhg==
X-Received: from ejcty16.prod.google.com ([2002:a17:907:c710:b0:c29:490f:9a3d])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9406:b0:c31:73b8:39b3 with SMTP id a640c23a62f3a-c4679796deemr525575766b.30.1792673407508;
 Thu, 22 Oct 2026 05:50:07 -0700 (PDT)
Date: Thu, 22 Oct 2026 12:50:06 +0000
In-Reply-To: <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-3-tarunsahu@google.com>
 <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com>
Message-ID: <9huzik2t5281.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 2/4] liveupdate: Select file handler by name in the
 preserve ioctl
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, linux-pci@vger.kernel.org, 
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9B974C0002
X-Stat-Signature: a1cswutotqssz6tc1tcecirjdjjqa66s
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792673409-536437
X-HE-Meta: U2FsdGVkX18JaZ9Ko8gldeOqwtT6Ay/yo5o9++t8AkzpLbtWDLUtVAwcyd/JbRJgghvjcHCGsoDf1kitKQ3vCSCXGzle+QNLHUD+oawd5XMMbBdlvOdbntM9B07laXLKugOvZLTH+Ane/dXt+M3W0h2wBn9fAjqT4gwTbkpwT3FQ66lWCWtjq61JGgJxVKiRJSIjvxzkGbx9muyDnW8vIBC20cG+rA/lJ6AUmaGDpHz6GLeMFHBgyKnnr9HyY89ff1fy919dh34EzuCNCVwkb7Z1lr+K15tcKcuXoxiIWaaaYovvj/70UHxiPkx0ghJ1rxn4CIEsDU6kgUzk8v3RCyZlXX9wG+OEs2JGuRnK4an4t+u7Zr4KAHE34w7TN1rMdMzPJlz/ygrxpOo7jhwVgrkzjuMUixnRHvKWt/DppzhaTKI4pBUX0ShE3dn6xMFfaUUO+ubmeo04ekwROrug5agxu7IZFx8bVVhpj5eUJE6SQUOSkMJLrqr9X9ghU5OtwzdSalnrsmg4kJr0a4o3sWch+SVEP550K1ypo2Ai/8cKvD5LcK06uDdsm94V/mQUHyVbG4j5uZWPqr4HKGLFPkzUZ6ReQkZYRhzzgWqGpOGNLpIR+EejjFlRCztaQyWynscFilRpv9OQw71E+9BvWdOEhgSevemqD6AOAoUrFJnsds+/cw5UcE/c7jh8R6URtFeXrPGCejhsYioznq8wS9HBZsTS9XlB3lNm3VN+i4sTgXC9P3uGlh8QP6egQDJ1H3uWI7DxfKGysLjR2mzzjIsF/rc/EEOcUuYST5G7gop7M+ZMEupnDJTLrIV/kt1gtFtRo4WsUT7hKb8cbCa7avKhDth1Df9ZalH1aB7YolJv0Q5fk12Sxr42u/X9QLfCfbwR8s+U4QRCnhh1sydJHjDvnV7ZlGC652JjTAMRutp7pMw9N1pEpstdMoxnqJTtv20mJ2Fk4rIeMy05eBs
 DCrWljjn
 hOj3An3wODVO+IYC8P4eRiXwS5513LD/yV5660ONyICwM6fZcLmCyfYtcYEerhYdYQ3I1nWMjzKiIG7+A+6ei5caT6ps/sgGdQLIeCTW/7zgGxNAx2ATKX5UcJeGzl09fL4BJBIY6gnnE4j/Bg6GY6EJfbUc/zppB+MFP14I1L9LTbMIEJRXggDtL4zfTH8e8oo3eakVsPf+yZcySbxl/BxUq0XU4ZzX8SlMkhcayJt4Qqxp2Hs1SOavPFuvu8SI4GrfivDO5kC3xEi1UlaV9YoHsDN8MXpGZ7oh423WKRVmVX9SJ9Y7O5h2to0+Q5hkr6eFhzVVJmz0K2tL23t4mUVQrGYqJDaRvNS4r6DlaiwpPX3TuLAAgOi7xrG9MtBCyYnhQKsRvKZHSdRlCDpkDbaxCojfcpBI98B0fTuHwzQD27k1dBcXGsxt+gNCLOOE6Z7Pskfkgaj0sw52IKqfGdgatElfHrXc6sMCx4caG1Efr0QF4FZXleq3sVT2Xtv1rSSFqpzmRsMu+7CET9JHN9rhI84bYAwGrkLH8uWuuRhYYhgSBtD5/ohflhdnUrbHHu5HeWSVs53IrbfAh2XGvvLrnshsMa+jSfUg0C3341B1h917vhhumXFThlL8DpPhgjlAMRB0Blbrh0oI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


I have gone through the discussion in reply to this thread between
@dmatlack and @pasha

I am not sure If I understood the discussion correctly.

userspace IOCTL for FLB compatiblity might not necessary as each FLBs are
registered with the file handler. So when new file handler introduced in th=
e
system, new flb handlers can be registered that is compatible with this
new file handler. I have tried to explain this below.

Pasha Tatashin <pasha.tatashin@soleen.com> writes:

> On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.com=
> wrote:
>>
>> Currently luo_preserve_file() iterates over luo_file_handler_list and
>> picks the first registered handler whose .can_preserve() callback
>> returns true. When a subsystem introduces a new, backwards-incompatible
>> file handler alongside an existing one for the same file type, userspace
>> has no way to choose which handler preserves a file descriptor, nor can
>> the kernel keep the existing rollback-safe handler as the default while
>> allowing callers to opt into the new handler.
>
> That is not how it will work.
> If we are in the .can_preserve() call,
> it means the user has already decided which file handlers to use.

That is not true.

From the documentation of the luo_preserve_file(): 3rd point.

* This function orchestrates the first phase of preserving a file. It perfo=
rms
 * the following steps:
 *
 * 1. Validates that the @token is not already in use within the file_set.
 * 2. Ensures the file_set's memory for files serialization is allocated
 *    (allocates if needed).
=3D>* 3. Iterates through registered handlers, calling can_preserve() to fi=
nd one
 *    compatible with the given @fd.
 * 4. Calls the handler's .preserve() operation, which saves the file's sta=
te
 *    and returns an opaque private data handle.
 * 5. Adds the new instance to the file_set's internal list.
 *

luo_preserve_file():

	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
		if (fh->ops->can_preserve(fh, file)) {
			if (try_module_get(fh->ops->owner))
				err =3D 0;
			break;
		}
	}


the first handler whose can_preserve return true will be selected as the
FH;

later in code:

      	err =3D fh->ops->preserve(&args);

So can_preserve() is called on every handler for a fd and once it finds
the FH which reutrns true, it uses its preserve call to preserve the file.

> We
> need to do that before any preservation happens; otherwise, we could
> run into conflicts on FLBs i.e. FH of different version require
> different FLBs.

My change below will select the user passed handler directly if it is
valid otherwise it fallbacks to looping .can_preserve based selection.

****For flb****:

Registration of flb handlers happens with original
subsytem fd handler, for example, for iommu

 iommu_liveupdate_register_flb(&iommufd_ser_handler); ->liveupdate_register=
_flb(fh, flb);

This function takes the FH argument. So every FH has direct relation
with their flbs.

If new FH will be introduced within the system, it must register
compatible flbs handlers with it by liveupdate_register_flb.

Currently, FLB objects are preserved with the first dependent file's
preservation. and each flb handler in fh->flb_list (was associated
using each flb handler registration) will call its ops to preserve itself.

Same on retrieval side, handler name is preserved so the flb name is
also preserved. And they can just call their respects ops to retrieve
themselves.

What about If user try to preserve other dependent but same subsystem
files with different handler. Kernel must reject this. I have not
integrated this support. Which can also be added as part of this series.
Let me know if this sounds good, Then I will add that in the V3?

~Tarun

>
> Therefore, there should be a luoctl call (i.e via a new ioctl to set
> compatability) that provides the kernel with the specs file of the
> target kernel we are updating to, allowing the kernel to select the
> compatible file handlers. Since .can_preserve() is called when the
> user is already preserving files, the specification must have already
> been supplied, or the kernel should fall back to using the default
> (i.e., latest) file handlers.
>
>>
>> Append char handler[LIVEUPDATE_HNDL_NAME_LENGTH] to struct
>> liveupdate_session_preserve_fd immediately after token, keeping
>> IOCTL_OP min_size at offsetofend(..., token) so callers passing the
>> original 16-byte structure continue to work:
>> - When handler is empty (all-zero, or zero-filled when userspace
>>   passes the 16-byte structure), luo_preserve_file() selects the first
>>   registered handler whose .can_preserve() callback accepts the fd.
>> - When handler is non-empty, it must be null-terminated within
>>   LIVEUPDATE_HNDL_NAME_LENGTH bytes (returning -EINVAL otherwise);
>>   luo_preserve_file() looks up the registered handler with that exact
>>   name (returning -ENOENT if unknown) and verifies that its
>>   .can_preserve() callback accepts the fd (returning -EINVAL if not).
>>
>> The retrieve ioctl is unchanged because the handler is identified by the
>> name stored in the serialized payload from the source kernel.
>>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  include/uapi/linux/liveupdate.h  | 12 +++++++++---
>>  kernel/liveupdate/luo_file.c     | 21 ++++++++++++++++++---
>>  kernel/liveupdate/luo_internal.h |  3 ++-
>>  kernel/liveupdate/luo_session.c  |  7 ++++++-
>>  4 files changed, 35 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveup=
date.h
>> index 509c6236720d..2413b19dabc1 100644
>> --- a/include/uapi/linux/liveupdate.h
>> +++ b/include/uapi/linux/liveupdate.h
>> @@ -126,9 +126,14 @@ struct liveupdate_ioctl_retrieve_session {
>>
>>  /**
>>   * struct liveupdate_session_preserve_fd - ioctl(LIVEUPDATE_SESSION_PRE=
SERVE_FD)
>> - * @size:  Input; sizeof(struct liveupdate_session_preserve_fd)
>> - * @fd:    Input; The user-space file descriptor to be preserved.
>> - * @token: Input; An opaque, unique token for preserved resource.
>> + * @size:    Input; sizeof(struct liveupdate_session_preserve_fd)
>> + * @fd:      Input; The user-space file descriptor to be preserved.
>> + * @token:   Input; An opaque, unique token for preserved resource.
>> + * @handler: Input; Optional null-terminated file handler name (max len=
gth
>> + *           %LIVEUPDATE_HNDL_NAME_LENGTH including null terminator) se=
lecting
>> + *           which registered handler preserves @fd. If empty (all-zero=
, or
>> + *           omitted when passing the 16-byte structure), the kernel se=
lects
>> + *           the first registered handler whose .can_preserve() accepts=
 @fd.
>>   *
>>   * Holds parameters for preserving a file descriptor.
>>   *
>> @@ -152,6 +157,7 @@ struct liveupdate_session_preserve_fd {
>>         __u32           size;
>>         __s32           fd;
>>         __aligned_u64   token;
>> +       char            handler[LIVEUPDATE_HNDL_NAME_LENGTH];
>>  };
>>
>>  #define LIVEUPDATE_SESSION_PRESERVE_FD                                 =
\
>> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>> index fb81239bedf3..be20e0f1e0aa 100644
>> --- a/kernel/liveupdate/luo_file.c
>> +++ b/kernel/liveupdate/luo_file.c
>> @@ -207,6 +207,8 @@ static bool luo_token_is_used(struct luo_file_set *f=
ile_set, u64 token)
>>   * @file_set: The file_set to which the preserved file will be added.
>>   * @token:    A unique, user-provided identifier for the file.
>>   * @fd:       The file descriptor to be preserved.
>> + * @handler:  Optional NUL-terminated handler name. If NULL or empty, t=
he first
>> + *            registered handler whose .can_preserve() accepts @fd is s=
elected.
>>   *
>>   * This function orchestrates the first phase of preserving a file. Upo=
n entry,
>>   * it takes a reference to the 'struct file' via fget(), effectively ma=
king LUO
>> @@ -238,11 +240,13 @@ static bool luo_token_is_used(struct luo_file_set =
*file_set, u64 token)
>>   *         -EBUSY if the file descriptor is already preserved by anothe=
r session.
>>   *         -EBADF if the file descriptor is invalid.
>>   *         -ENOSPC if the file_set is full.
>> - *         -ENOENT if no compatible handler is found for the file type.
>> + *         -ENOENT if no matching handler is registered or accepts @fd.
>> + *         -EINVAL if the named handler cannot preserve @fd.
>>   *         -ENOMEM on memory allocation failure.
>>   *         Other erros might be returned by .preserve().
>>   */
>> -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
>> +                     const char *handler)
>>  {
>>         struct liveupdate_file_op_args args =3D {0};
>>         struct liveupdate_file_handler *fh;
>> @@ -266,6 +270,18 @@ int luo_preserve_file(struct luo_file_set *file_set=
, u64 token, int fd)
>>         err =3D -ENOENT;
>>         down_read(&luo_register_rwlock);
>>         list_private_for_each_entry(fh, &luo_file_handler_list, list) {
>> +               if (handler && handler[0]) {
>> +                       if (strcmp(fh->name, handler))
>> +                               continue;
>> +                       if (!fh->ops->can_preserve(fh, file)) {
>> +                               err =3D -EINVAL;
>> +                               break;
>> +                       }
>> +                       if (try_module_get(fh->ops->owner))
>> +                               err =3D 0;
>> +                       break;
>> +               }
>> +
>>                 if (fh->ops->can_preserve(fh, file)) {
>>                         if (try_module_get(fh->ops->owner))
>>                                 err =3D 0;
>> @@ -274,7 +290,6 @@ int luo_preserve_file(struct luo_file_set *file_set,=
 u64 token, int fd)
>>         }
>>         up_read(&luo_register_rwlock);
>>
>> -       /* err is still -ENOENT if no handler was found */
>>         if (err)
>>                 goto err_fput;
>>
>> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_in=
ternal.h
>> index dac6644bfb18..911ffedec9f3 100644
>> --- a/kernel/liveupdate/luo_internal.h
>> +++ b/kernel/liveupdate/luo_internal.h
>> @@ -101,7 +101,8 @@ int __init luo_session_setup_incoming(u64 sessions_p=
a);
>>  int luo_session_serialize(void);
>>  int luo_session_deserialize(void);
>>
>> -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)=
;
>> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
>> +                     const char *handler);
>>  void luo_file_unpreserve_files(struct luo_file_set *file_set);
>>  int luo_file_freeze(struct luo_file_set *file_set,
>>                     struct luo_file_set_ser *file_set_ser);
>> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_ses=
sion.c
>> index f48e9a4185f9..194ef45907c1 100644
>> --- a/kernel/liveupdate/luo_session.c
>> +++ b/kernel/liveupdate/luo_session.c
>> @@ -266,8 +266,13 @@ static int luo_session_preserve_fd(struct luo_sessi=
on *session,
>>         struct liveupdate_session_preserve_fd *argp =3D ucmd->cmd;
>>         int err;
>>
>> +       if (strnlen(argp->handler, sizeof(argp->handler)) =3D=3D
>> +           sizeof(argp->handler))
>> +               return -EINVAL;
>> +
>>         guard(mutex)(&session->mutex);
>> -       err =3D luo_preserve_file(&session->file_set, argp->token, argp-=
>fd);
>> +       err =3D luo_preserve_file(&session->file_set, argp->token, argp-=
>fd,
>> +                               argp->handler);
>>         if (err)
>>                 return err;
>>
>> --
>> 2.56.0.212.g129ede20d9-goog
>>

